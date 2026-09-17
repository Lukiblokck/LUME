const std = @import("std");

pub const Key = union(enum) {
    character: u8,
    enter,
    backspace,
    escape,
    tab,
    arrow_up,
    arrow_down,
    arrow_left,
    arrow_right,
    ctrl_x,
    ctrl_o,
    ctrl_s,
    ctrl_q,
};

pub fn readKey() !Key {
    var buffer: [1]u8 = undefined;

    while (true) {
        const n = try std.io.getStdIn().read(&buffer);

        if (n == 0) continue;

        const byte = buffer[0];

        switch (byte) {
            24 => return .{ .ctrl_x = {} },
            9 => return .{ .tab = {} },
            10, 13 => return .{ .enter = {} },
            27 => return readEscapeSequence(),
            127 => return .{ .backspace = {} },
            else => {
                if (byte >= 1 and byte <= 26) {
                    return switch (byte) {
                        15 => .{ .ctrl_o = {} },
                        17 => .{ .ctrl_q = {} },
                        19 => .{ .ctrl_s = {} },
                        else => .{ .character = byte },
                    };
                }

                return .{ .character = byte };
            },
        }
    }
}

fn readEscapeSequence() !Key {
    var buffer: [2]u8 = undefined;

    const n = try std.io.getStdIn().read(&buffer);

    if (n == 0) {
        return .{ .escape = {} };
    }

    if (buffer[0] != '[') {
        return .{ .escape = {} };
    }

    if (n < 2) {
        return .{ .escape = {} };
    }

    return switch (buffer[1]) {
        'A' => .{ .arrow_up = {} },
        'B' => .{ .arrow_down = {} },
        'C' => .{ .arrow_right = {} },
        'D' => .{ .arrow_left = {} },
        else => .{ .escape = {} },
    };
}
