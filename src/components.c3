// Higher-level HTML components built from the low-level node primitives.
// These provide convenient shortcuts for common HTML patterns.
module c3mponents::components;

import c3mponents;
import c3mponents::html;

// ── HTML5 document template ───────────────────────────────────────────────────

// Html5Props holds the properties for a complete HTML5 document.
struct Html5Props
{
    String  title;        // Required: document title
    String  description;  // Optional: meta description
    String  language;     // Optional: html lang attribute (e.g. "en")
    Node*[] head;         // Optional: additional <head> children
    Node*[] body;         // Required: <body> children
}

// html5 creates a complete HTML5 document node.
// It renders as: <!doctype html><html lang="..."><head>...</head><body>...</body></html>
//
// Example:
//   Node* page = components::html5({
//       .title    = "My App",
//       .language = "en",
//       .body     = { html::h1(c3mponents::text("Hello!")) },
//   });
fn Node* html5(Html5Props p)
{
    return c3mponents::doctype(
        html::html_el(
            c3mponents::if_node(p.language.len > 0, html::lang(p.language)),
            html::head(
                html::meta(html::charset("utf-8")),
                html::meta(
                    html::name("viewport"),
                    html::content("width=device-width, initial-scale=1")
                ),
                html::title_el(c3mponents::text(p.title)),
                c3mponents::if_node(
                    p.description.len > 0,
                    html::meta(
                        html::name("description"),
                        html::content(p.description)
                    )
                ),
                c3mponents::group(...p.head),
            ),
            html::body(
                c3mponents::group(...p.body),
            ),
        ),
    );
}

// ── Navigation helper ─────────────────────────────────────────────────────────

// nav_link creates an <a> tag styled as active when href matches current_path.
// The "active" class is added when href == current_path.
//
// Example:
//   nav_link("/about", "About", current_path)
fn Node* nav_link(String href_val, String label, String current_path)
{
    bool is_active = href_val == current_path;
    return html::a(
        html::href(href_val),
        c3mponents::if_node(is_active, html::class_attr("active")),
        c3mponents::text(label),
    );
}
