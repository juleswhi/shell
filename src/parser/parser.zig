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
    const executables = try getExecutablesInPath(std.heap.page_allocator);
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

pub fn getExecutablesInPath(allocator: std.mem.Allocator) !std.ArrayList([]const u8) {
    const path_var = std.process.getEnvVarOwned(allocator, "PATH") catch return error.MissingPath;
    defer allocator.free(path_var);

    var path_list = std.ArrayList([]const u8).init(allocator);
    errdefer path_list.deinit();

    var split_iter = std.mem.splitSequence(u8, path_var, ":");
    while (split_iter.next()) |path| {
        var dir = try std.fs.openDirAbsolute(path, .{});
        defer dir.close();

        var dir_iter = dir.iterate();
        while (try dir_iter.next()) |entry| {
            if (entry.kind == .file) {
                std.debug.print("{s}\n", .{entry.name});
            }
        }
    }

    return path_list;
}

