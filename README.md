<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LUME — Lightweight Universal Modal Editor</title>
</head>

<body>

<header>
    <h1>LUME</h1>
    <p><strong>Lightweight Universal Modal Editor</strong></p>

```
<p>
    A fast, lightweight and developer-focused terminal text editor
    written in Zig.
</p>

<img src="img/screenshot.png" alt="LUME editor screenshot" width="900">
```

</header>

<hr>

<section>
    <h2>About</h2>

```
<p>
    LUME is a lightweight terminal text editor written in Zig,
    designed for developers who want a powerful editing environment
    without sacrificing performance, memory efficiency or simplicity.
</p>

<p>
    LUME aims to combine the familiar editing experience of Nano
    with advanced functionality inspired by modern editors such as
    Neovim, while keeping its core small, fast and efficient.
</p>

<p>
    Development initially targets Linux, while the architecture is
    designed with future BSD and GNU/Hurd support in mind.
</p>
```

</section>

<section>
    <h2>Goals</h2>

```
<ul>
    <li>Fast startup and responsive editing.</li>
    <li>Extremely low memory and CPU usage.</li>
    <li>Efficient handling of very large files.</li>
    <li>Full UTF-8 support.</li>
    <li>Developer-oriented features.</li>
    <li>Nano-like keybindings by default.</li>
    <li>Optional advanced modal editing.</li>
    <li>Optional plugin support.</li>
    <li>Linux-first development with cross-platform architecture.</li>
    <li>Free and open-source software under the GNU GPL v3.</li>
</ul>
```

</section>

<section>
    <h2>Features</h2>

```
<h3>Core Editor</h3>

<ul>
    <li>Terminal-based interface</li>
    <li>UTF-8 support</li>
    <li>File opening and saving</li>
    <li>Cursor movement</li>
    <li>Text insertion and deletion</li>
    <li>Text selection</li>
    <li>Undo and redo</li>
    <li>Search and replace</li>
    <li>Multiple buffers</li>
    <li>Multiple files</li>
    <li>Tabs</li>
    <li>File explorer</li>
</ul>

<h3>Developer Features</h3>

<ul>
    <li>Syntax highlighting</li>
    <li>Configurable themes</li>
    <li>Language Server Protocol support</li>
    <li>Code completion</li>
    <li>Diagnostics</li>
    <li>Go to definition</li>
    <li>Symbol references</li>
    <li>Symbol renaming</li>
    <li>Code formatting</li>
    <li>Git integration</li>
</ul>

<h3>Extensibility</h3>

<ul>
    <li>Plugin API</li>
    <li>Plugin manager</li>
    <li>Custom commands</li>
    <li>Custom keybindings</li>
    <li>Custom themes</li>
</ul>
```

</section>

<section>
    <h2>Keybindings</h2>

```
<p>
    LUME uses Nano-like keybindings by default.
    The goal is to make the editor immediately familiar to users
    without requiring them to learn a new editing system.
</p>

<table>
    <thead>
        <tr>
            <th>Shortcut</th>
            <th>Action</th>
        </tr>
    </thead>

    <tbody>
        <tr>
            <td><code>Ctrl + O</code></td>
            <td>Save</td>
        </tr>
        <tr>
            <td><code>Ctrl + X</code></td>
            <td>Exit</td>
        </tr>
        <tr>
            <td><code>Ctrl + W</code></td>
            <td>Search</td>
        </tr>
        <tr>
            <td><code>Ctrl + K</code></td>
            <td>Cut</td>
        </tr>
        <tr>
            <td><code>Ctrl + U</code></td>
            <td>Paste</td>
        </tr>
        <tr>
            <td><code>Ctrl + G</code></td>
            <td>Help</td>
        </tr>
    </tbody>
</table>

<p>
    LUME will also provide an optional modal editing mode inspired
    by Vim and Neovim for users who want more advanced navigation
    and editing capabilities.
</p>
```

</section>

<section>
    <h2>Configuration</h2>

```
<p>
    LUME will use JSONC for its configuration files.
    JSONC provides the simplicity of JSON while allowing comments
    and making configuration easier to maintain.
</p>

<pre><code>{
// Editor
"tab_width": 4,
"line_numbers": true,
"relative_numbers": false,

// Appearance
"theme": "default",
"syntax_highlighting": true,

// Behaviour
"autosave": false
```

}</code></pre>

```
<p>Configuration files will be stored in:</p>

<pre><code>~/.config/lume/</code></pre>

<p>Example:</p>

<pre><code>~/.config/lume/
```

├── config.jsonc
├── keybindings.jsonc
└── themes/</code></pre>

</section>

<section>
    <h2>Performance</h2>

```
<p>
    Performance is a fundamental part of LUME's design.
    Memory usage, startup time and responsiveness are treated as
    core features rather than secondary optimizations.
</p>

<p>LUME is designed to:</p>

<ul>
    <li>Start as quickly as possible.</li>
    <li>Use as little memory as practical.</li>
    <li>Avoid unnecessary allocations.</li>
    <li>Avoid blocking the user interface.</li>
    <li>Render only what needs to be rendered.</li>
    <li>Handle large files efficiently.</li>
    <li>Perform expensive operations asynchronously when appropriate.</li>
</ul>

<p>
    Large files should not automatically result in an equally large
    memory footprint.
</p>

<p>
    Performance will be evaluated through benchmarks and profiling
    rather than assumptions.
</p>

<h3>Planned Benchmarks</h3>

<ul>
    <li>Startup time</li>
    <li>Memory usage</li>
    <li>CPU usage</li>
    <li>File loading</li>
    <li>Text editing</li>
    <li>Search</li>
    <li>Replace</li>
    <li>Rendering</li>
    <li>Syntax highlighting</li>
    <li>LSP responsiveness</li>
</ul>
```

</section>

<section>
    <h2>Large File Handling</h2>

```
<p>
    LUME is designed with large files in mind from the beginning.
    The editor should not require an entire file to be copied into
    memory simply because it has been opened.
</p>

<p>
    The buffer architecture will be evaluated around efficient
    data structures and storage strategies such as chunked storage,
    piece tables, ropes and memory mapping where appropriate.
</p>

<p>
    The final implementation will be selected according to real
    benchmarks, memory usage and editing performance.
</p>
```

</section>

<section>
    <h2>Architecture</h2>

```
<p>
    LUME is designed around a small editor core with platform-specific
    functionality isolated from the rest of the application.
</p>

<pre><code>
                     LUME
                       |
         +-------------+-------------+
         |             |             |
       Core         Terminal      Platform
         |             |             |
  +------+------+      |       +-----+-----+
  |      |      |      |       |     |     |
```

Buffer Cursor  Undo  Renderer  Linux  BSD  Hurd
|
+-- Search
+-- Selection
+-- Files

```
         +-------------+-------------+
         |             |             |
      Syntax          LSP           Git
         |
      Plugins
</code></pre>

<p>
    The core should remain independent of operating-system-specific
    implementation details wherever possible.
</p>
```

</section>

<section>
    <h2>Project Structure</h2>

```
<pre><code>lume/
```

├── LICENSE
├── README.md
├── CONTRIBUTING.md
├── CHANGELOG.md
├── build.zig
├── build.zig.zon
│
├── src/
│   ├── main.zig
│   │
│   ├── core/
│   │   ├── editor.zig
│   │   ├── buffer.zig
│   │   ├── cursor.zig
│   │   ├── selection.zig
│   │   ├── undo.zig
│   │   └── search.zig
│   │
│   ├── terminal/
│   │   ├── terminal.zig
│   │   ├── input.zig
│   │   ├── output.zig
│   │   ├── raw_mode.zig
│   │   └── capabilities.zig
│   │
│   ├── renderer/
│   │   ├── renderer.zig
│   │   ├── screen.zig
│   │   └── theme.zig
│   │
│   ├── syntax/
│   │   ├── syntax.zig
│   │   ├── lexer.zig
│   │   └── languages/
│   │
│   ├── lsp/
│   │   ├── client.zig
│   │   ├── protocol.zig
│   │   └── transport.zig
│   │
│   ├── git/
│   │   └── git.zig
│   │
│   ├── plugins/
│   │   ├── manager.zig
│   │   └── api.zig
│   │
│   ├── config/
│   │   ├── config.zig
│   │   └── jsonc.zig
│   │
│   └── platform/
│       ├── platform.zig
│       ├── linux.zig
│       ├── bsd.zig
│       └── hurd.zig
│
└── tests/</code></pre>

</section>

<section>
    <h2>Platform Support</h2>

```
<table>
    <thead>
        <tr>
            <th>Platform</th>
            <th>Status</th>
        </tr>
    </thead>

    <tbody>
        <tr>
            <td>Linux</td>
            <td>Primary development target</td>
        </tr>
        <tr>
            <td>FreeBSD</td>
            <td>Planned</td>
        </tr>
        <tr>
            <td>OpenBSD</td>
            <td>Planned</td>
        </tr>
        <tr>
            <td>NetBSD</td>
            <td>Planned</td>
        </tr>
        <tr>
            <td>GNU/Hurd</td>
            <td>Planned</td>
        </tr>
    </tbody>
</table>

<p>
    Linux is the primary development platform. Portability is considered
    throughout the architecture so that support for other Unix-like
    systems can be implemented without rewriting the editor core.
</p>
```

</section>

<section>
    <h2>Building</h2>

```
<p>
    LUME is written in Zig.
</p>

<pre><code>git clone https://github.com/Lukiblokck/lume.git
```

cd lume</code></pre>

```
<p>Build the project:</p>

<pre><code>zig build</code></pre>

<p>Run LUME:</p>

<pre><code>zig build run</code></pre>

<p>
    Build instructions may change during early development.
</p>
```

</section>

<section>
    <h2>Development</h2>

```
<p>Format the source code:</p>

<pre><code>zig fmt .</code></pre>

<p>Build the project:</p>

<pre><code>zig build</code></pre>

<p>Run the test suite:</p>

<pre><code>zig build test</code></pre>

<p>
    Continuous integration, performance benchmarks and profiling
    will be expanded as the project matures.
</p>
```

</section>

<section>
    <h2>Roadmap</h2>

```
<h3>0.1 — Foundation</h3>

<ul>
    <li>Project structure</li>
    <li>Terminal raw mode</li>
    <li>Keyboard input</li>
    <li>Terminal renderer</li>
    <li>UTF-8 foundation</li>
    <li>Text buffer</li>
    <li>Cursor</li>
    <li>Text insertion</li>
    <li>Text deletion</li>
    <li>File opening</li>
    <li>File saving</li>
    <li>Nano-like keybindings</li>
</ul>

<h3>0.2 — Editor</h3>

<ul>
    <li>Scrolling</li>
    <li>Line numbers</li>
    <li>Status bar</li>
    <li>Selection</li>
    <li>Undo and redo</li>
    <li>Search</li>
    <li>Replace</li>
    <li>Clipboard support</li>
    <li>Multiple buffers</li>
</ul>

<h3>0.3 — Performance</h3>

<ul>
    <li>Large-file architecture</li>
    <li>Efficient buffer implementation</li>
    <li>Memory benchmarks</li>
    <li>Startup benchmarks</li>
    <li>Rendering benchmarks</li>
    <li>Profiling</li>
    <li>Performance regression tests</li>
</ul>

<h3>0.4 — Developer Experience</h3>

<ul>
    <li>Syntax highlighting</li>
    <li>Themes</li>
    <li>JSONC configuration</li>
    <li>Configurable keybindings</li>
    <li>Multiple files</li>
    <li>Tabs</li>
    <li>File explorer</li>
</ul>

<h3>0.5 — Language Support</h3>

<ul>
    <li>LSP client</li>
    <li>Diagnostics</li>
    <li>Autocompletion</li>
    <li>Go to definition</li>
    <li>References</li>
    <li>Rename</li>
    <li>Formatting</li>
</ul>

<h3>0.6 — Git</h3>

<ul>
    <li>Git status</li>
    <li>Git diff</li>
    <li>Git blame</li>
    <li>Branch information</li>
    <li>Merge conflict support</li>
</ul>

<h3>0.7 — Extensibility</h3>

<ul>
    <li>Plugin API</li>
    <li>Plugin manager</li>
    <li>Custom commands</li>
    <li>Plugin configuration</li>
</ul>

<h3>1.0 — Stable</h3>

<p>
    A stable, fast and lightweight terminal development environment
    with mature Linux support and a portable architecture prepared
    for BSD and GNU/Hurd.
</p>
```

</section>

<section>
    <h2>Philosophy</h2>

```
<blockquote>
    <p><strong>Performance is a feature.</strong></p>
</blockquote>

<p>
    Every feature added to LUME should be evaluated against its impact
    on performance, memory usage, startup time, dependencies and
    responsiveness.
</p>

<p>Before adding a feature, LUME should ask:</p>

<ul>
    <li>Does it significantly increase memory usage?</li>
    <li>Does it slow down startup?</li>
    <li>Can it block the editor?</li>
    <li>Does it introduce unnecessary dependencies?</li>
    <li>Can it be implemented more efficiently?</li>
    <li>Does it belong in the core or should it be optional?</li>
</ul>

<p>
    LUME should remain lightweight at its core even as its feature set
    grows.
</p>
```

</section>

<section>
    <h2>Contributing</h2>

```
<p>
    LUME is currently developed primarily as an independent project.
    Contributions may be accepted as the project matures.
</p>

<p>Before submitting changes, make sure the project passes:</p>

<pre><code>zig fmt .
```

zig build
zig build test</code></pre>

```
<p>
    Contributions should respect LUME's goals of performance,
    low memory usage, portability, maintainability and simplicity.
</p>
```

</section>

<section>
    <h2>License</h2>

```
<p>
    LUME is free and open-source software licensed under the
    <strong>GNU General Public License v3.0</strong>.
</p>

<p>
    See <a href="LICENSE">LICENSE</a> for the complete license text.
</p>
```

</section>

<section>
    <h2>Project Status</h2>

```
<p>
    <strong>Early development.</strong>
</p>

<p>
    LUME is currently under active development. The architecture,
    configuration format, API and feature set may change significantly
    before the first stable release.
</p>
```

</section>

<hr>

<footer>
    <h2>LUME</h2>
    <p>Lightweight Universal Modal Editor</p>
    <p>Built with Zig.</p>
</footer>

</body>
</html>
