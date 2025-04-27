const std = @import("std");

pub fn parse(input: []const u8) ![]const u8 {
    if(std.mem.eql(u8, input, "exit")) {
        std.os.linux.exit(0);
    }
    return input;
}
