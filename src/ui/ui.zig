const renderer = @import("../renderer/renderer.zig");
const header = @import("header.zig");
const text_area = @import("text_area.zig");
const file_tree = @import("file_tree.zig");
const status_bar = @import("status_bar.zig");
const buffer = @import("../text/buffer.zig");

pub const UI = struct {
    header: header.Header,
    text_area: text_area.TextArea,
    file_tree: file_tree.FileTree,
    status_bar: status_bar.StatusBar,
    buffer: buffer.Buffer,

    pub fn init() UI {
        return .{
            .header = header.Header.init(),
            .text_area = text_area.TextArea.init(),
            .file_tree = file_tree.FileTree.init("."),
            .status_bar = status_bar.StatusBar.init(),
            .buffer = buffer.Buffer.init(),
        };
    }

    pub fn deinit(self: *UI) void {
        self.buffer.deinit();
        self.file_tree.deinit();
    }

    pub fn openSelected(self: *UI) !void {
        const selected = self.file_tree.selectedEntry() orelse return;

        if (selected.kind != .file) {
            return;
        }

        try self.buffer.loadFile(selected.path);
    }

    pub fn draw(
        self: *UI,
        render: *renderer.Renderer,
        line: usize,
        column: usize,
    ) !void {
        try self.header.draw(render);

        try self.file_tree.draw(render);

        try self.text_area.draw(
            render,
        );

        try self.status_bar.draw(
            render,
            line,
            column,
        );
    }
};

