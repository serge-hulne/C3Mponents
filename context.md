# C3Components — Project Context

## What We Built

A pure-C3 HTML generator library inspired by Go's [Gomponents](https://github.com/maragudk/gomponents).
The goal: compose HTML documents programmatically using plain C3 functions, with no template
language, no strings, and full compiler support (type checking, auto-complete, formatting).

---

## Project Layout

```
C3Components/
├── project.json              # Build config (executable target "example")
├── context.md                # This file
└── src/
    ├── node.c3               # Core Node type and rendering engine
    ├── core.c3               # Constructor functions (el, attr, text, …)
    ├── html/
    │   ├── elements.c3       # All HTML5 element constructors
    │   └── attrs.c3          # All HTML5 attribute constructors
    ├── components.c3         # High-level components (html5, nav_link)
    └── example.c3            # Runnable demo (main)
```

---

## Module Structure

| C3 Module                  | File(s)                          | Role |
|----------------------------|----------------------------------|------|
| `c3mponents`               | `node.c3`, `core.c3`             | Core types and primitive constructors |
| `c3mponents::html`         | `html/elements.c3`, `html/attrs.c3` | Every HTML5 element and attribute |
| `c3mponents::components`   | `components.c3`                  | Higher-level helpers (HTML5 document, nav links) |
| `example`                  | `example.c3`                     | Demo / entry point (`main`) |

In C3, functions are accessed via the **last module segment**:
- `c3mponents::el()`, `c3mponents::text()`, `c3mponents::group()` …
- `html::div()`, `html::class_attr()`, `html::required()` …
- `components::html5()`, `components::nav_link()` …

Types (`Node`, `NodeKind`, `Html5Props`) require **no prefix** once the module is imported.

---

## Core Design

### The `Node` Struct (`node.c3`)

```c3
enum NodeKind : char {
    ELEM, ATTR, ATTR_BOOL, TEXT, RAW, GROUP, DOCTYPE, NONE
}

struct Node {
    NodeKind kind;
    String   name;      // tag name or attribute name
    String   content;   // attribute value or text content
    Node*[]  children;  // child nodes (for ELEM, GROUP, DOCTYPE)
}
```

Every HTML construct—elements, attributes, text, raw content, groups—is a `Node*`.

### Rendering (`Node.render`)

Rendering is a two-pass process for elements (matching Gomponents' design):
1. **Attribute pass** — walk children, render only `ATTR`/`ATTR_BOOL` nodes into the opening tag.
2. **Element pass** — walk children, render only non-attribute nodes as content.

`GROUP` nodes are expanded transparently in both passes, so attributes buried inside a group
still land in the right place.

### Memory Strategy

All allocation uses C3's **temp allocator** (`tnew`, `talloc_array`).
Users wrap rendering in `@pool()` for automatic cleanup — zero manual `free()`:

```c3
@pool() {
    Node* page = components::html5({ ... });
    DString buf;
    buf.tinit(4096);
    page.render(&buf);
    io::printn(buf.str_view());
};
// all temp memory freed here
```

---

## API Reference

### Core primitives (`c3mponents`)

| Function | Description |
|---|---|
| `el(tag, children...)` | Create an HTML element node |
| `attr(name, value)` | Attribute with value, e.g. `class="foo"` |
| `bool_attr(name)` | Boolean attribute, e.g. `required` |
| `text(s)` | HTML-escaped text node |
| `textf(fmt, args...)` | Formatted, HTML-escaped text node |
| `raw(s)` | Unescaped raw content |
| `group(children...)` | Transparent wrapper around multiple nodes |
| `if_node(cond, node)` | Return node if true, null otherwise |
| `doctype(sibling)` | Prepend `<!doctype html>` before sibling |
| `node.render(&buf)` | Render node to a `DString` |
| `node.to_string()` | Render node to a temp `String` |

### HTML5 elements (`c3mponents::html`)

All standard HTML5 elements are provided as functions.
Elements that conflict with C3 keywords or have name clashes get an `_el` suffix:

| C3 function | HTML output |
|---|---|
| `html::html_el(...)` | `<html>...</html>` |
| `html::head(...)` | `<head>...</head>` |
| `html::body(...)` | `<body>...</body>` |
| `html::title_el(...)` | `<title>...</title>` |
| `html::div(...)` | `<div>...</div>` |
| `html::main_el(...)` | `<main>...</main>` |
| `html::select_el(...)` | `<select>...</select>` |
| `html::style_el(...)` | `<style>...</style>` |
| `html::time_el(...)` | `<time>...</time>` |
| `html::data_el(...)` | `<data>...</data>` |
| `html::var_el(...)` | `<var>...</var>` |
| … all others use the HTML name directly | |

Void elements (`img`, `input`, `br`, `hr`, `meta`, `link`, `source`, etc.) are handled
automatically — no closing tag is rendered.

### HTML5 attributes (`c3mponents::html`)

Attributes that conflict with C3 keywords or other names get a `_attr` suffix:

| C3 function | HTML output |
|---|---|
| `html::class_attr("foo")` | `class="foo"` |
| `html::style_attr("color:red")` | `style="color:red"` |
| `html::type_attr("text")` | `type="text"` |
| `html::for_attr("id")` | `for="id"` |
| `html::form_attr("id")` | `form="id"` |
| `html::label_attr("x")` | `label="x"` |
| `html::cite_attr("url")` | `cite="url"` |
| `html::title_attr("tip")` | `title="tip"` |
| `html::slot_attr("name")` | `slot="name"` |
| `html::async_attr()` | `async` |
| `html::defer_attr()` | `defer` |
| `html::loop_attr()` | `loop` |
| `html::open_attr()` | `open` |
| `html::required()` | `required` |
| `html::disabled()` | `disabled` |
| `html::checked()` | `checked` |
| … all others use the HTML name directly | |

#### Prefixed attribute helpers

```c3
html::aria("label", "Close")        // → aria-label="Close"
html::data_attr("user-id", "42")    // → data-user-id="42"
html::hx("get", "/api/data")        // → hx-get="/api/data"
```

### Higher-level components (`c3mponents::components`)

**`html5(Html5Props)`** — complete HTML5 document:
```c3
struct Html5Props {
    String  title;        // required
    String  description;  // optional: <meta name="description">
    String  language;     // optional: <html lang="...">
    Node*[] head;         // optional: extra <head> children
    Node*[] body;         // required: <body> children
}
```

**`nav_link(href, label, current_path)`** — `<a>` with `class="active"` when active.

---

## Usage Pattern

```c3
import std::io;
import std::core::dstring;
import c3mponents;
import c3mponents::html;
import c3mponents::components;

fn Node* my_page() {
    return components::html5({
        .title    = "My App",
        .language = "en",
        .head     = {
            html::link(html::rel("stylesheet"), html::href("/app.css")),
        },
        .body     = {
            html::nav(
                components::nav_link("/",     "Home",  "/"),
                components::nav_link("/about","About", "/"),
            ),
            html::main_el(
                html::class_attr("container"),
                html::h1(c3mponents::text("Hello, World!")),
                html::p(c3mponents::text("Welcome to my C3 app.")),
                c3mponents::if_node(user_logged_in, profile_section()),
            ),
        },
    });
}

fn void main() {
    @pool() {
        DString buf;
        buf.tinit(4096);
        my_page().render(&buf);
        io::printn(buf.str_view());
    };
}
```

---

## Reference Documentation

- **C3 language docs**: `../../docs/` (relative to this project)
- **Gomponents source reference**: `../../Gomponents-docs/gomponents/`
- **C3 stdlib source**: `../../docs/stdlib-source/`

---

## Build & Run

```sh
c3c build        # compiles to build/example
./build/example  # runs the demo
```

---

## Design Decisions & Tradeoffs

| Decision | Rationale |
|---|---|
| Temp allocator by default | Matches C3 server idiom; users get free cleanup via `@pool()` |
| Tagged union (`NodeKind`) instead of interfaces | Avoids interface complexity; simple and fast |
| Two-pass rendering (attr/element) | Matches Gomponents design; allows attributes anywhere in child list |
| `GROUP` expands transparently | Lets you pass pre-built attribute groups to multiple elements |
| `_el`/`_attr` suffix for name conflicts | Disambiguates without breaking naming conventions |
| Separate `c3mponents` and `c3mponents::html` modules | Short `html::` prefix for elements; avoids polluting core namespace |
