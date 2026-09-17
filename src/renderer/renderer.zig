const std = @import("std");
const terminal = @import("../terminal/terminal.zig");

pub const Renderer = struct {
    width: usize,
    height: usize,

    pub fn init() !Renderer {
        const size = try terminal.getSize();

        return .{
            .width = size.width,
            .height = size.height,
        };
    }

    pub fn updateSize(self: *Renderer) !bool {
        const size = try terminal.getSize();

        if (size.width == self.width and size.height == self.height) {
            return false;
        }

        self.width = size.width;
        self.height = size.height;

        return true;
    }

    pub fn clear(self: *Renderer) !void {
        _ = self;

        const stdout = std.io.getStdOut().writer();
        try stdout.writeAll("\x1b[2J\x1b[H");
    }

    pub fn refresh(self: *Renderer) !void {
        _ = self;
    }

    pub fn moveCursor(
        self: *Renderer,
        row: usize,
        column: usize,
    ) !void {
        _ = self;

        const stdout = std.io.getStdOut().writer();

        try stdout.print(
            "\x1b[{d};{d}H",
            .{ row, column },
        );
    }

    pub fn hideCursor(self: *Renderer) !void {
        _ = self;

        const stdout = std.io.getStdOut().writer();
        try stdout.writeAll("\x1b[?25l");
    }

    pub fn showCursor(self: *Renderer) !void {
        _ = self;

        const stdout = std.io.getStdOut().writer();
        try stdout.writeAll("\x1b[?25h");
    }

    pub fn drawText(
        self: *Renderer,
        text: []const u8,
    ) !void {
        _ = self;

        const stdout = std.io.getStdOut().writer();
        try stdout.writeAll(text);
    }
};
