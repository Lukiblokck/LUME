const renderer = @import("../renderer/renderer.zig");

pub const TextArea = struct {
    pub fn init() TextArea {
        return .{};
    }

    pub fn draw(
        self: *TextArea,
        render: *renderer.Renderer,
    ) !void {
        _ = self;

        const start_column: usize = 24;

        if (render.height <= 2) return;
        if (render.width <= start_column) return;

        var row: usize = 2;

        while (row < render.height) : (row += 1) {
            try render.moveCursor(row, start_column);
            try render.drawText("│");
        }
    }
};

