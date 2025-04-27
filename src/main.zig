const std = @import("std");
const out = @import("shell/out.zig");

const parse = @import("parser/parser.zig").parse;

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    while (true) {
        try out.outPrompt(try getUsername());

        var buf: [1024]u8 = undefined;

        const result = try stdin.readUntilDelimiter(&buf, '\n');

        try out.outStd(result);
        try out.outErr(result);
    }
}

fn getUsername() ![]const u8 {
    return try std.process.getEnvVarOwned(std.heap.page_allocator, "USER");
}
