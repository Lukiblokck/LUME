const c = @cImport({
    @cInclude("termios.h");
    @cInclude("unistd.h");
});

var original: c.struct_termios = undefined;
var enabled = false;

pub fn enable() !void {
    if (enabled) return;

    if (c.tcgetattr(c.STDIN_FILENO, &original) != 0) {
        return error.TcGetAttrFailed;
    }

    var raw = original;

    raw.c_iflag &= ~@as(@TypeOf(raw.c_iflag), c.BRKINT | c.ICRNL | c.INPCK | c.ISTRIP | c.IXON);
    raw.c_oflag &= ~@as(@TypeOf(raw.c_oflag), c.OPOST);
    raw.c_cflag |= c.CS8;
    raw.c_lflag &= ~@as(@TypeOf(raw.c_lflag), c.ECHO | c.ICANON | c.IEXTEN | c.ISIG);

    raw.c_cc[c.VMIN] = 0;
    raw.c_cc[c.VTIME] = 1;

    if (c.tcsetattr(c.STDIN_FILENO, c.TCSAFLUSH, &raw) != 0) {
        return error.TcSetAttrFailed;
    }

    enabled = true;
}

pub fn disable() void {
    if (!enabled) return;

    _ = c.tcsetattr(c.STDIN_FILENO, c.TCSAFLUSH, &original);
    enabled = false;
}

pub fn restore() void {
    disable();
}

