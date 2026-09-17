const c = @cImport({
    @cInclude("sys/ioctl.h");
    @cInclude("unistd.h");
});

pub const Size = struct {
    width: usize,
    height: usize,
};

pub fn getSize() !Size {
    var window_size: c.struct_winsize = undefined;

    if (c.ioctl(c.STDOUT_FILENO, c.TIOCGWINSZ, &window_size) == -1) {
        return error.IoctlFailed;
    }

    return .{
        .width = window_size.ws_col,
        .height = window_size.ws_row,
    };
}
