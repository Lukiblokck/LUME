const raw_mode = @import("terminal/raw_mode.zig");
const input = @import("terminal/input.zig");
const renderer = @import("renderer/renderer.zig");
const ui = @import("ui/ui.zig");

pub fn main() !void {
    try raw_mode.enable();
    defer raw_mode.disable();

    var render = try renderer.Renderer.init();
    var interface = ui.UI.init();

    try render.clear();
    try render.hideCursor();
    defer render.showCursor() catch {};

    try interface.draw(
        &render,
        1,
        1,
    );

    try render.refresh();

    while (true) {
        const key = try input.readKey();

        switch (key) {
            .ctrl_x => break,

            .arrow_up => {
                interface.file_tree.moveUp();
            },

            .arrow_down => {
                interface.file_tree.moveDown(
                    render.height,
                );
            },

            .arrow_right => {
                interface.file_tree.expand();
            },

            .arrow_left => {
                interface.file_tree.collapse();
            },
            .enter => {
                try interface.openSelected();
            },
            else => {},
        }

        try render.clear();

        try interface.draw(
            &render,
            1,
            1,
        );

        try render.refresh();
    }
}
