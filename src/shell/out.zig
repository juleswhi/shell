const std = @import("std");
const fmt = @import("fmt.zig");

const WRITER = std.io.getStdOut().writer();
const READER = std.io.getStdIn().reader();

pub fn outStd(str: []const u8) !void {
    try WRITER.print("{s}\n", .{str});
}

pub fn outErr(str: []const u8) !void {

    try WRITER.print("{s} - '{s}' - {s}\n", .{fmt.bold(fmt.italic("twsh")), fmt.magenta(fmt.italic(str)), fmt.err("command not found") });
}

pub fn outPrompt(str: []const u8) !void {
    try WRITER.print("[{s}] $ ", .{str});
}
