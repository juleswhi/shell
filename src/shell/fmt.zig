const std = @import("std");
const tty = std.io.tty;

/// Detect terminal color support once (reuse this for multiple color calls)
fn getColorConfig() tty.Config {
    return tty.detectConfig(std.io.getStdOut());
}

// Helper to wrap text with ANSI codes (caller must free the returned string)
fn wrapColor(
    allocator: std.mem.Allocator,
    str: []const u8,
    comptime ansi_code: []const u8,
) []const u8 {
    return std.fmt.allocPrint(
        allocator,
        "\x1b[{s}m{s}\x1b[0m",
        .{ ansi_code, str },
    ) catch unreachable;
}

fn wrapStyle(
    allocator: std.mem.Allocator,
    str: []const u8,
    comptime ansi_code: []const u8,
) []const u8 {
    return std.fmt.allocPrint(
        allocator,
        "\x1b[{s}m{s}\x1b[0m",
        .{ ansi_code, str },
    ) catch unreachable;
}

pub fn red(str: []const u8) []const u8 {
    return wrapColor(std.heap.page_allocator, str, "31");
}

pub fn green(str: []const u8) []const u8 {
    return wrapColor(std.heap.page_allocator, str, "32");
}

pub fn yellow(str: []const u8) []const u8 {
    return wrapColor(std.heap.page_allocator, str, "33");
}

pub fn blue(str: []const u8) []const u8 {
    return wrapColor(std.heap.page_allocator, str, "34");
}

pub fn magenta(str: []const u8) []const u8 {
    return wrapColor(std.heap.page_allocator, str, "35");
}

pub fn cyan(str: []const u8) []const u8 {
    return wrapColor(std.heap.page_allocator, str, "36");
}

pub fn white(str: []const u8) []const u8 {
    return wrapColor(std.heap.page_allocator, str, "37");
}

pub fn brightRed(str: []const u8) []const u8 {
    return wrapColor(std.heap.page_allocator, str, "91");
}

pub fn brightGreen(str: []const u8) []const u8 {
    return wrapColor(std.heap.page_allocator, str, "92");
}

pub fn brightYellow(str: []const u8) []const u8 {
    return wrapColor(std.heap.page_allocator, str, "93");
}

pub fn brightBlue(str: []const u8) []const u8 {
    return wrapColor(std.heap.page_allocator, str, "94");
}

pub fn brightMagenta(str: []const u8) []const u8 {
    return wrapColor(std.heap.page_allocator, str, "95");
}

pub fn brightCyan(str: []const u8) []const u8 {
    return wrapColor(std.heap.page_allocator, str, "96");
}

pub fn brightWhite(str: []const u8) []const u8 {
    return wrapColor(std.heap.page_allocator, str, "97");
}

pub fn bold(str: []const u8) []const u8 {
    return wrapStyle(std.heap.page_allocator, str, "1");
}

pub fn dim(str: []const u8) []const u8 {
    return wrapStyle(std.heap.page_allocator, str, "2");
}

pub fn italic(str: []const u8) []const u8 {
    return wrapStyle(std.heap.page_allocator, str, "3");
}

pub fn underline(str: []const u8) []const u8 {
    return wrapStyle(std.heap.page_allocator, str, "4");
}

pub fn blink(str: []const u8) []const u8 {
    return wrapStyle(std.heap.page_allocator, str, "5");
}

pub fn fastBlink(str: []const u8) []const u8 {
    return wrapStyle(std.heap.page_allocator, str, "6");
}

pub fn inverse(str: []const u8) []const u8 {
    return wrapStyle(std.heap.page_allocator, str, "7");
}

pub fn hidden(str: []const u8) []const u8 {
    return wrapStyle(std.heap.page_allocator, str, "8");
}

pub fn strikethrough(str: []const u8) []const u8 {
    return wrapStyle(std.heap.page_allocator, str, "9");
}

pub fn err(str: []const u8) []const u8 {
    return underline(bold(red(str)));
}
