const std_lib = @import("std");
const fmt = @import("fmt.zig");

const WRITER = std_lib.io.getStdOut().writer();
const READER = std_lib.io.getStdIn().reader();

pub fn print(str: []const u8) !void {
    try WRITER.print("{s}\n", .{str});
}

pub fn write(str: []const u8) !void {
    try WRITER.print("{s}", .{str});
}

pub fn err(str: []const u8) !void {
    try WRITER.print("{s} - '{s}' - {s}\n", .{fmt.bold(fmt.italic("twsh")), fmt.magenta(fmt.italic(str)), fmt.err("command not found") });
}

pub fn prompt(str: []const u8) !void {
    try WRITER.print("[{s}] $ ", .{str});
}

pub fn backspace() !void {
    _ = try WRITER.write("\x08 \x08");
}

pub fn line() !void {
    _ = try print("");
}
