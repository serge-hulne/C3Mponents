# C3Mponents

> HTML generation in pure C3 — no templates, no strings, just functions.

Inspired by Go's [Gomponents](https://github.com/maragudk/gomponents), **C3Mponents** lets you
build HTML5 documents by composing plain C3 functions. The compiler checks your work, your editor
autocompletes everything, and XSS escaping is on by default.

```c3
fn Node* greeting_card(String name, bool is_admin) {
    return html::div(
        html::class_attr("card"),
        html::h2(c3mponents::text(name)),
        c3mponents::if_node(is_admin, html::span(
            html::class_attr("badge"),
            c3mponents::text("Admin"),
        )),
    );
}
```

```html
<!-- Output -->
<div class="card"><h2>Alice</h2><span class="badge">Admin</span></div>
```

---

## Why Not Templates?

| | Templates | C3Mponents |
|---|---|---|
| Type safety | None | Full — the compiler catches mistakes |
| Refactoring | Find-and-replace strings | Rename a function, compiler updates callers |
| Reuse | Partials, includes, macros | Plain functions |
| XSS safety | Depends on the engine | `text()` always escapes; `raw()` is explicit |
| Tooling | Separate language | Standard C3 formatter, debugger, LSP |
| Memory | Hidden allocations | Explicit temp allocator, freed by `@pool()` |

---

## Modules

| Import | Prefix | Contents |
|---|---|---|
| `c3mponents` | `c3mponents::` | Core types and primitives |
| `c3mponents::html` | `html::` | All HTML5 elements and attributes |
| `c3mponents::components` | `components::` | Higher-level helpers |

---

## Quick Start

```c3
import std::io;
import std::core::dstring;
import c3mponents;
import c3mponents::html;
import c3mponents::components;

fn void main() {
    @pool() {
        Node* page = components::html5({
            .title    = "Hello",
            .language = "en",
            .body     = {
                html::h1(c3mponents::text("Hello, World!")),
            },
        });

        DString buf;
        buf.tinit(4096);
        page.render(&buf);
        io::printn(buf.str_view());
    };
}
```

**Output:**
```html
<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Hello</title></head><body><h1>Hello, World!</h1></body></html>
```

---

## Build

```sh
c3c build        # → build/example
./build/example
```

---

## Core Primitives

These live in the `c3mponents` module.

### Nodes

| Function | Output |
|---|---|
| `el("tag", children...)` | Generic element — use when no helper exists |
| `text("Hello <World>")` | `Hello &lt;World&gt;` — always HTML-escaped |
| `textf("Hi %s!", name)` | Formatted, HTML-escaped text |
| `raw("<b>bold</b>")` | Unescaped — use only for trusted content |
| `group(nodes...)` | Transparent wrapper; attributes inside a group are still placed in the parent's opening tag |
| `if_node(cond, node)` | Include `node` only when `cond` is true; returns null otherwise |
| `doctype(sibling)` | Prepends `<!doctype html>` before `sibling` |

### Rendering

```c3
// Render to a DString buffer
node.render(&buf);

// Render to a temp String (within @pool())
String s = node.to_string();
```

---

## HTML5 Elements

All standard HTML5 elements are available as `html::name(children...)`.

A handful use a `_el` suffix to avoid conflicts with C3 keywords or attribute names:

```c3
html::html_el(...)    // <html>
html::title_el(...)   // <title>   (title is also an attribute)
html::style_el(...)   // <style>   (style is also an attribute)
html::main_el(...)    // <main>
html::select_el(...)  // <select>
html::time_el(...)    // <time>
html::data_el(...)    // <data>
html::var_el(...)     // <var>
```

**Void elements** (`img`, `input`, `br`, `hr`, `meta`, `link`, `source`, `embed`, `track`, …)
are handled automatically — no closing tag is emitted.

---

## HTML5 Attributes

All standard HTML5 attributes are available as `html::name(value)`.

Attributes that clash with element names or C3 keywords use a `_attr` suffix:

```c3
html::class_attr("container")    // class="container"
html::style_attr("color:red")    // style="color:red"
html::type_attr("text")          // type="text"
html::for_attr("field-id")       // for="field-id"
html::form_attr("form-id")       // form="form-id"
html::title_attr("Tooltip")      // title="Tooltip"
html::cite_attr("url")           // cite="url"
html::label_attr("text")         // label="text"
html::slot_attr("name")          // slot="name"
html::async_attr()               // async
html::defer_attr()               // defer
html::loop_attr()                // loop
html::open_attr()                // open
```

**Boolean attributes** (no value) are plain calls:

```c3
html::required()    // required
html::disabled()    // disabled
html::checked()     // checked
html::readonly()    // readonly
html::multiple()    // multiple
html::selected()    // selected
html::autofocus()   // autofocus
html::muted()       // muted
```

### Prefixed Attribute Helpers

```c3
html::aria("label", "Close dialog")   // aria-label="Close dialog"
html::data_attr("user-id", "42")      // data-user-id="42"
html::hx("get", "/api/items")         // hx-get="/api/items"
```

---

## Higher-Level Components

### `components::html5` — Complete HTML5 Document

```c3
struct Html5Props {
    String  title;        // <title> content (required)
    String  description;  // <meta name="description"> (optional)
    String  language;     // <html lang="..."> (optional)
    Node*[] head;         // extra <head> children (optional)
    Node*[] body;         // <body> children (required)
}

Node* page = components::html5({
    .title       = "My App",
    .description = "An amazing C3 application.",
    .language    = "en",
    .head        = {
        html::link(html::rel("stylesheet"), html::href("/app.css")),
        html::script(html::src("/app.js"), html::defer_attr()),
    },
    .body        = { ... },
});
```

### `components::nav_link` — Navigation Link

```c3
// Renders <a href="/about">About</a>
// Adds class="active" when href == current_path
components::nav_link("/about", "About", current_path)
```

---

## Patterns

### Reusable Components

Components are just functions that return `Node*`:

```c3
fn Node* alert(String kind, String message) {
    return html::div(
        html::role("alert"),
        html::class_attr(kind),
        c3mponents::text(message),
    );
}

// Usage
alert("error",   "Something went wrong.")
alert("success", "Saved successfully.")
```

### Conditional Rendering

```c3
c3mponents::if_node(user.is_admin, admin_panel())
c3mponents::if_node(items.len > 0, item_list(items))
```

### Sharing Attributes with Groups

A `group` of attributes can be reused across multiple elements:

```c3
Node* row_attrs = c3mponents::group(
    html::class_attr("table-row"),
    html::role("row"),
);

html::tr(row_attrs, /* cells... */)
html::tr(row_attrs, /* cells... */)
```

### Server-Side Rendering

All allocations use the temp allocator. Each HTTP request gets its own `@pool()` scope:

```c3
fn void handle_request(HttpRequest* req, HttpResponse* res) {
    @pool() {
        Node* page = my_page(req);
        DString buf;
        buf.tinit(8192);
        page.render(&buf);
        res.body = buf.str_view().copy(res.allocator);
    }; // entire HTML tree freed here
}
```

---

## Project Structure

```
C3Components/
├── project.json
├── README.md
├── context.md              ← detailed technical notes
└── src/
    ├── node.c3             ← Node struct, rendering engine, html_escape
    ├── core.c3             ← el, attr, text, raw, group, if_node, doctype
    ├── html/
    │   ├── elements.c3     ← HTML5 element constructors
    │   └── attrs.c3        ← HTML5 attribute constructors
    ├── components.c3       ← html5(), nav_link()
    └── example.c3          ← runnable demo
```

---

## How It Works

Every HTML construct — elements, attributes, text, raw content — is a `Node*` allocated on the
temp pool. The renderer does two passes over an element's children:

1. **Attribute pass** — writes `ATTR` and `ATTR_BOOL` nodes into the opening tag
2. **Element pass** — writes `TEXT`, `RAW`, `ELEM`, and `GROUP` nodes as content

`GROUP` nodes are expanded transparently in both passes, so attributes buried inside a group
still land correctly in the parent's opening tag.

---

## License

MIT
