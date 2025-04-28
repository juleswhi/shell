const fmt = @import("../shell/fmt.zig");
const std = @import("std");
const os = std.os;
const fs = std.fs;
const mem = std.mem;
const ArrayList = std.ArrayList;

pub const twsh_err = error{
    command_not_found,
};

pub fn parse(str: []const u8) ![]const u8 {
    _ = str;
    const executables = try getExecutables(std.heap.page_allocator);
    defer {
        for (executables.items) |exe| {
            std.heap.page_allocator.free(exe);
        }
        executables.deinit();
    }

    for (executables.items) |exe| {
        std.debug.print("{s}\n", .{exe});
    }

    return fmt.err("command not found");
}

pub fn getExecutables(allocator: mem.Allocator) !ArrayList([]const u8) {
    var executables = ArrayList([]const u8).init(allocator);
    errdefer executables.deinit();

    const path_env = std.process.getEnvVarOwned(std.heap.page_allocator, "PATH") catch return error.NotPathFound;
    var dirs = mem.splitAny(u8, path_env, ":");

    while (dirs.next()) |dir_path| {
        if (dir_path.len == 0) continue;

        var dir = fs.openDirAbsolute(dir_path, .{}) catch unreachable;
        defer dir.close();

        var iter = dir.iterate();
        while (true) {
            const maybe_entry = iter.next();
            if (maybe_entry) |entry_opt| {
                if (entry_opt) |entry| {
                    const full_path = fs.path.join(allocator, &[_][]const u8{ dir_path, entry.name }) catch |err| {
                        // Handle allocation error (e.g., out of memory)
                        return err;
                    };
                    defer allocator.free(full_path);

                    executables.append(full_path) catch |err| {
                        allocator.free(full_path);
                        return err;
                    };
                } else {
                    break;
                }
            } else |_| {
                // Skip entry on error
                continue;
            }
        }
    }

    return executables;
}
