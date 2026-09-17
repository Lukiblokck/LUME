const std = @import("std");
const renderer = @import("../renderer/renderer.zig");

pub const StatusBar = struct {
    pub fn init() StatusBar {
        return .{};
    }

    pub fn draw(
        self: *StatusBar,
        render: *renderer.Renderer,
        line: usize,
        column: usize,
    ) !void {
        _ = self;

        try render.moveCursor(render.height, 2);
        try render.drawText("NORMAL");

        try render.moveCursor(render.height, 11);
        try render.drawText("UTF-8");

        const stdout = std.io.getStdOut().writer();

        if (render.width > 20) {
            const position = 20;

            try render.moveCursor(render.height, render.width - position);

            try stdout.print(
                "Ln {d}, Col {d}",
                .{
                    line,
                    column,
                },
            );
        }
    }
};
