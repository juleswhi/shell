const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();
    while (true) {
        try stdout.print("[{s}] $ ", .{try getUsername()});

        var buf: [1024]u8 = undefined;

        const result = try stdin.readUntilDelimiter(&buf, '\n');

        try stdout.print("twsh: {s}\n", .{result});
    }
    stdout.print("\n", .{});
}

fn getUsername() ![]const u8 {
    const user = try std.process.getEnvVarOwned(std.heap.page_allocator, "USER");
    // Attempt to get the username from the USERNAME environment variable

    return user;
}
