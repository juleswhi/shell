// main.zig
const std = @import("std");
const os = std.os;
const system = std.os.system;
const out = @import("shell/out.zig");
const linux = std.os.linux;

const c = std.c;

const parse = @import("parser/parser.zig").parse;

pub fn main() !void {
    const stdin = std.io.getStdIn();
    const stderr = std.io.getStdErr();
    const stdin_reader = stdin.reader();

    // Save original terminal settings

    // Save original terminal settings using Linux syscall

    var original_termios: linux.termios = undefined;
    const tcget_ret = linux.tcgetattr(stdin.handle, &original_termios);
    if (tcget_ret < 0) return os.errno(-tcget_ret);

    defer {
        _ = linux.tcsetattr(stdin.handle, .FLUSH, &original_termios);
    }

    // Configure raw terminal mode
    var raw_termios = original_termios;
    raw_termios.lflag.ICANON = false;
    raw_termios.lflag.ECHO = true;
    raw_termios.cc[@intFromEnum(linux.V.TIME)] = 0;
    raw_termios.cc[@intFromEnum(linux.V.MIN)] = 1;

    const tcset_ret = linux.tcsetattr(stdin.handle, .FLUSH, &raw_termios);
    if (tcset_ret < 0) return os.errno(-tcset_ret);

    var input_buffer: [1024]u8 = undefined;
    var input_index: usize = 0;

    while (true) {
        try out.outPrompt(try getUsername());

        // Read input character by character
        while (true) {
            const char = stdin_reader.readByte() catch |err| {
                if (err == error.EndOfStream) continue;
                return err;
            };

            switch (char) {
                '\n' => { // Enter key
                    input_buffer[input_index] = 0;
                    const input = input_buffer[0..input_index];
                    input_index = 0;

                    // Process command
                    try processInput(input);
                    break;
                },
                0x7F => { // Backspace
                    if (input_index > 0) {
                        input_index -= 1;
                        try stderr.writeAll("\x08 \x08"); // Erase character
                    }
                },
                0x0C => { // Ctrl+L
                    try clearScreen();
                    try out.outPrompt(try getUsername());
                    try stderr.writeAll(input_buffer[0..input_index]);
                },
                0x03 => { // Ctrl+C
                    input_index = 0;
                    try stderr.writeAll("^C\n");
                    try out.outPrompt(try getUsername());
                },
                else => {
                    if (input_index < input_buffer.len - 1 and char >= 0x20 and char <= 0x7E) {
                        input_buffer[input_index] = char;
                        input_index += 1;
                    }
                },
            }
        }
    }
}

fn processInput(input: []const u8) !void {
    // Your command processing logic here
    try out.outErr(try parse(input));
}

fn clearScreen() !void {
    try std.io.getStdErr().writeAll("\x1b[2J\x1b[H");
}

fn getUsername() ![]const u8 {
    return try std.process.getEnvVarOwned(std.heap.page_allocator, "USER");
}
