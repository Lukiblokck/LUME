const std = @import("std");
const renderer = @import("../renderer/renderer.zig");

const EntryKind = enum {
    file,
    directory,
};

const Entry = struct {
    name: []const u8,
    path: []const u8,
    kind: EntryKind,
    depth: usize,
};

pub const FileTree = struct {
    root_path: []const u8,
    width: usize,

    entries: std.ArrayList(Entry),
    selected: usize,
    scroll: usize,

    expanded_paths: std.ArrayList([]const u8),

    entry_arena: std.heap.ArenaAllocator,
    state_arena: std.heap.ArenaAllocator,

    pub fn init(path: []const u8) FileTree {
        return .{
            .root_path = path,
            .width = 24,

            .entries = std.ArrayList(Entry).init(std.heap.page_allocator),
            .selected = 0,
            .scroll = 0,

            .expanded_paths = std.ArrayList([]const u8).init(
                std.heap.page_allocator,
            ),

            .entry_arena = std.heap.ArenaAllocator.init(
                std.heap.page_allocator,
            ),

            .state_arena = std.heap.ArenaAllocator.init(
                std.heap.page_allocator,
            ),
        };
    }

    pub fn deinit(self: *FileTree) void {
        self.entries.deinit();
        self.expanded_paths.deinit();

        self.entry_arena.deinit();
        self.state_arena.deinit();
    }

    pub fn draw(
        self: *FileTree,
        render: *renderer.Renderer,
    ) !void {
        self.width = calculateWidth(render.width);

        try self.rebuild();

        if (self.entries.items.len == 0) {
            try render.moveCursor(4, 2);
            try render.drawText("(empty)");
        } else {
            self.clampSelection();

            const visible_height =
                if (render.height > 5)
                    render.height - 5
                else
                    1;

            if (self.selected < self.scroll) {
                self.scroll = self.selected;
            }

            if (self.selected >= self.scroll + visible_height) {
                self.scroll =
                    self.selected - visible_height + 1;
            }

            var row: usize = 4;
            var index: usize = self.scroll;

            while (
                index < self.entries.items.len and
                row < render.height
            ) : ({
                index += 1;
                row += 1;
            }) {
                try self.drawEntry(
                    render,
                    &self.entries.items[index],
                    index == self.selected,
                    row,
                );
            }
        }

        try self.drawSeparator(render);
    }

    fn rebuild(self: *FileTree) !void {
        _ = self.entry_arena.reset(.retain_capacity);

        self.entries.clearRetainingCapacity();

        try self.readDirectory(
            self.root_path,
            0,
        );
    }

    fn readDirectory(
        self: *FileTree,
        path: []const u8,
        depth: usize,
    ) !void {
        var dir = std.fs.cwd().openDir(
            path,
            .{
                .iterate = true,
            },
        ) catch {
            return;
        };

        defer dir.close();

        var directories = std.ArrayList([]const u8).init(
            std.heap.page_allocator,
        );

        var files = std.ArrayList([]const u8).init(
            std.heap.page_allocator,
        );

        defer directories.deinit();
        defer files.deinit();

        var iterator = dir.iterate();

        while (try iterator.next()) |entry| {
            const name = try self.entry_arena.allocator().dupe(
                u8,
                entry.name,
            );

            switch (entry.kind) {
                .directory => {
                    try directories.append(name);
                },

                .file => {
                    try files.append(name);
                },

                else => {},
            }
        }

        std.sort.heap(
            []const u8,
            directories.items,
            {},
            lessThan,
        );

        std.sort.heap(
            []const u8,
            files.items,
            {},
            lessThan,
        );

        for (directories.items) |name| {
            const full_path = try self.joinPath(
                path,
                name,
            );

            try self.entries.append(.{
                .name = name,
                .path = full_path,
                .kind = .directory,
                .depth = depth,
            });

            if (self.isExpanded(full_path)) {
                try self.readDirectory(
                    full_path,
                    depth + 1,
                );
            }
        }

        for (files.items) |name| {
            const full_path = try self.joinPath(
                path,
                name,
            );

            try self.entries.append(.{
                .name = name,
                .path = full_path,
                .kind = .file,
                .depth = depth,
            });
        }
    }

    fn drawEntry(
        self: *FileTree,
        render: *renderer.Renderer,
        entry: *const Entry,
        selected: bool,
        row: usize,
    ) !void {
        try render.moveCursor(row, 1);

        if (selected) {
            try render.drawText("> ");
        } else {
            try render.drawText("  ");
        }

        var depth: usize = 0;

        while (depth < entry.depth) : (depth += 1) {
            try render.drawText("  ");
        }

        switch (entry.kind) {
            .directory => {
                if (self.isExpanded(entry.path)) {
                    try render.drawText("v ");
                } else {
                    try render.drawText("> ");
                }
            },

            .file => {
                try render.drawText("  ");
            },
        }

        try self.drawName(
            render,
            entry.name,
        );
    }

    fn drawName(
        self: *FileTree,
        render: *renderer.Renderer,
        name: []const u8,
    ) !void {
        const available =
            if (self.width > 4)
                self.width - 4
            else
                1;

        const length =
            if (name.len > available)
                available
            else
                name.len;

        try render.drawText(
            name[0..length],
        );
    }

    fn drawSeparator(
        self: *FileTree,
        render: *renderer.Renderer,
    ) !void {
        var row: usize = 1;

        while (row <= render.height) : (row += 1) {
            try render.moveCursor(
                row,
                self.width,
            );

            try render.drawText("|");
        }
    }

    pub fn moveUp(self: *FileTree) void {
        if (self.entries.items.len == 0) {
            return;
        }

        if (self.selected > 0) {
            self.selected -= 1;
        }

        if (self.selected < self.scroll) {
            self.scroll = self.selected;
        }
    }

    pub fn moveDown(
        self: *FileTree,
        height: usize,
    ) void {
        if (self.entries.items.len == 0) {
            return;
        }

        if (self.selected + 1 < self.entries.items.len) {
            self.selected += 1;
        }

        const visible =
            if (height > 5)
                height - 5
            else
                1;

        if (self.selected >= self.scroll + visible) {
            self.scroll =
                self.selected - visible + 1;
        }
    }

    pub fn expand(self: *FileTree) void {
        if (self.entries.items.len == 0) {
            return;
        }

        const entry =
            &self.entries.items[self.selected];

        if (entry.kind != .directory) {
            return;
        }

        if (self.isExpanded(entry.path)) {
            return;
        }

        const path = self.state_arena.allocator().dupe(
            u8,
            entry.path,
        ) catch return;

        self.expanded_paths.append(path) catch return;
    }

    pub fn collapse(self: *FileTree) void {
        if (self.entries.items.len == 0) {
            return;
        }

        const entry =
            &self.entries.items[self.selected];

        if (entry.kind != .directory) {
            return;
        }

        var index: usize = 0;

        while (index < self.expanded_paths.items.len) : (index += 1) {
            if (std.mem.eql(
                u8,
                self.expanded_paths.items[index],
                entry.path,
            )) {
                _ = self.expanded_paths.orderedRemove(index);
                break;
            }
        }
    }

    pub fn selectedEntry(
        self: *FileTree,
    ) ?Entry {
        if (self.entries.items.len == 0) {
            return null;
        }

        return self.entries.items[self.selected];
    }

    fn isExpanded(
        self: *FileTree,
        path: []const u8,
    ) bool {
        for (self.expanded_paths.items) |expanded| {
            if (std.mem.eql(
                u8,
                expanded,
                path,
            )) {
                return true;
            }
        }

        return false;
    }

    fn clampSelection(self: *FileTree) void {
        if (self.entries.items.len == 0) {
            self.selected = 0;
            self.scroll = 0;
            return;
        }

        if (self.selected >= self.entries.items.len) {
            self.selected =
                self.entries.items.len - 1;
        }
    }

    fn joinPath(
        self: *FileTree,
        parent: []const u8,
        child: []const u8,
    ) ![]const u8 {
        return std.fmt.allocPrint(
            self.entry_arena.allocator(),
            "{s}/{s}",
            .{
                parent,
                child,
            },
        );
    }

    fn calculateWidth(
        terminal_width: usize,
    ) usize {
        if (terminal_width < 50) {
            return 16;
        }

        if (terminal_width < 80) {
            return 20;
        }

        if (terminal_width < 120) {
            return 24;
        }

        return 28;
    }

    fn lessThan(
        _: void,
        a: []const u8,
        b: []const u8,
    ) bool {
        return std.mem.lessThan(
            u8,
            a,
            b,
        );
    }
};
