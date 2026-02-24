// HTML5 attribute constructors.
// Each function creates an attribute Node for the corresponding HTML attribute.
// Attribute nodes are automatically placed inside the element's opening tag.
//
// Boolean attributes (no value) use bool_attr() from the core module.
// Attributes with values use attr() from the core module.
module c3mponents::html;

import c3mponents;

// ── Boolean attributes (no value) ────────────────────────────────────────────

fn Node* async_attr()      => c3mponents::bool_attr("async");
fn Node* autofocus()       => c3mponents::bool_attr("autofocus");
fn Node* autoplay()        => c3mponents::bool_attr("autoplay");
fn Node* checked()         => c3mponents::bool_attr("checked");
fn Node* controls()        => c3mponents::bool_attr("controls");
fn Node* defer_attr()      => c3mponents::bool_attr("defer");
fn Node* disabled()        => c3mponents::bool_attr("disabled");
fn Node* form_novalidate() => c3mponents::bool_attr("formnovalidate");
fn Node* loop_attr()       => c3mponents::bool_attr("loop");
fn Node* multiple()        => c3mponents::bool_attr("multiple");
fn Node* muted()           => c3mponents::bool_attr("muted");
fn Node* open_attr()       => c3mponents::bool_attr("open");
fn Node* plays_inline()    => c3mponents::bool_attr("playsinline");
fn Node* readonly()        => c3mponents::bool_attr("readonly");
fn Node* required()        => c3mponents::bool_attr("required");
fn Node* selected()        => c3mponents::bool_attr("selected");

// ── Value attributes ──────────────────────────────────────────────────────────

fn Node* accept(String v)           => c3mponents::attr("accept", v);
fn Node* action(String v)           => c3mponents::attr("action", v);
fn Node* alt(String v)              => c3mponents::attr("alt", v);
fn Node* as_attr(String v)          => c3mponents::attr("as", v);
fn Node* autocomplete(String v)     => c3mponents::attr("autocomplete", v);
fn Node* charset(String v)          => c3mponents::attr("charset", v);
fn Node* cite_attr(String v)        => c3mponents::attr("cite", v);
fn Node* class_attr(String v)       => c3mponents::attr("class", v);
fn Node* cols(String v)             => c3mponents::attr("cols", v);
fn Node* colspan(String v)          => c3mponents::attr("colspan", v);
fn Node* content(String v)          => c3mponents::attr("content", v);
fn Node* crossorigin(String v)      => c3mponents::attr("crossorigin", v);
fn Node* datetime(String v)         => c3mponents::attr("datetime", v);
fn Node* dir(String v)              => c3mponents::attr("dir", v);
fn Node* download(String v)         => c3mponents::attr("download", v);
fn Node* draggable(String v)        => c3mponents::attr("draggable", v);
fn Node* enctype(String v)          => c3mponents::attr("enctype", v);
fn Node* for_attr(String v)         => c3mponents::attr("for", v);
fn Node* form_attr(String v)        => c3mponents::attr("form", v);
fn Node* form_action(String v)      => c3mponents::attr("formaction", v);
fn Node* form_enctype(String v)     => c3mponents::attr("formenctype", v);
fn Node* form_method(String v)      => c3mponents::attr("formmethod", v);
fn Node* form_target(String v)      => c3mponents::attr("formtarget", v);
fn Node* height(String v)           => c3mponents::attr("height", v);
fn Node* hidden(String v)           => c3mponents::attr("hidden", v);
fn Node* href(String v)             => c3mponents::attr("href", v);
fn Node* id(String v)               => c3mponents::attr("id", v);
fn Node* integrity(String v)        => c3mponents::attr("integrity", v);
fn Node* label_attr(String v)       => c3mponents::attr("label", v);
fn Node* lang(String v)             => c3mponents::attr("lang", v);
fn Node* list_attr(String v)        => c3mponents::attr("list", v);
fn Node* loading(String v)          => c3mponents::attr("loading", v);
fn Node* max(String v)              => c3mponents::attr("max", v);
fn Node* maxlength(String v)        => c3mponents::attr("maxlength", v);
fn Node* method(String v)           => c3mponents::attr("method", v);
fn Node* min(String v)              => c3mponents::attr("min", v);
fn Node* minlength(String v)        => c3mponents::attr("minlength", v);
fn Node* name(String v)             => c3mponents::attr("name", v);
fn Node* pattern(String v)          => c3mponents::attr("pattern", v);
fn Node* placeholder(String v)      => c3mponents::attr("placeholder", v);
fn Node* popover(String v)          => c3mponents::attr("popover", v);
fn Node* popover_target(String v)   => c3mponents::attr("popovertarget", v);
fn Node* popover_target_action(String v) => c3mponents::attr("popovertargetaction", v);
fn Node* poster(String v)           => c3mponents::attr("poster", v);
fn Node* preload(String v)          => c3mponents::attr("preload", v);
fn Node* referrer_policy(String v)  => c3mponents::attr("referrerpolicy", v);
fn Node* rel(String v)              => c3mponents::attr("rel", v);
fn Node* role(String v)             => c3mponents::attr("role", v);
fn Node* rows(String v)             => c3mponents::attr("rows", v);
fn Node* rowspan(String v)          => c3mponents::attr("rowspan", v);
fn Node* scope(String v)            => c3mponents::attr("scope", v);
fn Node* slot_attr(String v)        => c3mponents::attr("slot", v);
fn Node* spellcheck(String v)       => c3mponents::attr("spellcheck", v);
fn Node* src(String v)              => c3mponents::attr("src", v);
fn Node* srcset(String v)           => c3mponents::attr("srcset", v);
fn Node* step(String v)             => c3mponents::attr("step", v);
fn Node* style_attr(String v)       => c3mponents::attr("style", v);
fn Node* tabindex(String v)         => c3mponents::attr("tabindex", v);
fn Node* target(String v)           => c3mponents::attr("target", v);
fn Node* title_attr(String v)       => c3mponents::attr("title", v);
fn Node* type_attr(String v)        => c3mponents::attr("type", v);
fn Node* value(String v)            => c3mponents::attr("value", v);
fn Node* width(String v)            => c3mponents::attr("width", v);

// ── Prefixed attribute helpers ────────────────────────────────────────────────

// aria creates an ARIA attribute, automatically prepending "aria-".
// Example: aria("label", "Close") → aria-label="Close"
fn Node* aria(String name, String v)
{
    DString buf;
    buf.tinit(32);
    buf.append_chars("aria-");
    buf.append_chars(name);
    return c3mponents::attr(buf.str_view(), v);
}

// data_attr creates a data attribute, automatically prepending "data-".
// Example: data_attr("user-id", "42") → data-user-id="42"
fn Node* data_attr(String name, String v)
{
    DString buf;
    buf.tinit(32);
    buf.append_chars("data-");
    buf.append_chars(name);
    return c3mponents::attr(buf.str_view(), v);
}

// hx creates an HTMX attribute, automatically prepending "hx-".
// Example: hx("get", "/api/data") → hx-get="/api/data"
fn Node* hx(String name, String v)
{
    DString buf;
    buf.tinit(32);
    buf.append_chars("hx-");
    buf.append_chars(name);
    return c3mponents::attr(buf.str_view(), v);
}
