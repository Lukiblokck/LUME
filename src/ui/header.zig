const renderer = @import("../renderer/renderer.zig");

pub const Header = struct {
    pub fn init() Header {
        return .{};
    }

    pub fn draw(
        self: *Header,
        render: *renderer.Renderer,
    ) !void {
        _ = self;

        try render.moveCursor(1, 2);
        try render.drawText("LUME");

        if (render.width > 15) {
            const title = "[No Name]";
            const column = render.width - title.len - 1;

            try render.moveCursor(1, column);
            try render.drawText(title);
        }
    }
};
