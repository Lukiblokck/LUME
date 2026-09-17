const std = @import("std");

pub const Buffer = struct {
    path: ?[]const u8,
    content: std.ArrayList(u8),

    pub fn init() Buffer {
        return .{
            .path = null,
            .content = std.ArrayList(u8).init(
                std.heap.page_allocator,
            ),
        };
    }

    pub fn deinit(self: *Buffer) void {
        self.content.deinit();
    }

    pub fn loadFile(
        self: *Buffer,
        path: []const u8,
    ) !void {
        self.content.clearRetainingCapacity();

        const file = try std.fs.cwd().openFile(
            path,
            .{},
        );

        defer file.close();

        try file.reader().readAllArrayList(
            &self.content,
            std.math.maxInt(usize),
        );

        self.path = path;
    }

    pub fn isEmpty(self: *const Buffer) bool {
        return self.content.items.len == 0;
    }

    pub fn data(self: *const Buffer) []const u8 {
        return self.content.items;
    }
};

