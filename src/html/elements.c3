// HTML5 element constructors.
// Each function creates a Node for the corresponding HTML element.
// Children may be a mix of attribute nodes and element/text nodes.
//
// Usage:
//   import c3mponents;
//   import c3mponents::html;
//
//   Node* page = html::div(
//       html::class_attr("container"),
//       html::h1(c3mponents::text("Hello!")),
//   );
module c3mponents::html;

import c3mponents;

// ── Document structure ────────────────────────────────────────────────────────

fn Node* html_el(Node*... children) => c3mponents::el("html", ...children);
fn Node* head(Node*... children)    => c3mponents::el("head", ...children);
fn Node* body(Node*... children)    => c3mponents::el("body", ...children);
fn Node* title_el(Node*... children) => c3mponents::el("title", ...children);

// ── Metadata ──────────────────────────────────────────────────────────────────

fn Node* base(Node*... children)    => c3mponents::el("base", ...children);
fn Node* link(Node*... children)    => c3mponents::el("link", ...children);
fn Node* meta(Node*... children)    => c3mponents::el("meta", ...children);
fn Node* style_el(Node*... children) => c3mponents::el("style", ...children);
fn Node* script(Node*... children)  => c3mponents::el("script", ...children);
fn Node* noscript(Node*... children) => c3mponents::el("noscript", ...children);

// ── Sectioning ────────────────────────────────────────────────────────────────

fn Node* article(Node*... children)  => c3mponents::el("article", ...children);
fn Node* aside(Node*... children)    => c3mponents::el("aside", ...children);
fn Node* footer(Node*... children)   => c3mponents::el("footer", ...children);
fn Node* header(Node*... children)   => c3mponents::el("header", ...children);
fn Node* hgroup(Node*... children)   => c3mponents::el("hgroup", ...children);
fn Node* main_el(Node*... children)  => c3mponents::el("main", ...children);
fn Node* nav(Node*... children)      => c3mponents::el("nav", ...children);
fn Node* section(Node*... children)  => c3mponents::el("section", ...children);
fn Node* search(Node*... children)   => c3mponents::el("search", ...children);

// ── Headings ──────────────────────────────────────────────────────────────────

fn Node* h1(Node*... children) => c3mponents::el("h1", ...children);
fn Node* h2(Node*... children) => c3mponents::el("h2", ...children);
fn Node* h3(Node*... children) => c3mponents::el("h3", ...children);
fn Node* h4(Node*... children) => c3mponents::el("h4", ...children);
fn Node* h5(Node*... children) => c3mponents::el("h5", ...children);
fn Node* h6(Node*... children) => c3mponents::el("h6", ...children);

// ── Grouping content ──────────────────────────────────────────────────────────

fn Node* blockquote(Node*... children) => c3mponents::el("blockquote", ...children);
fn Node* dd(Node*... children)    => c3mponents::el("dd", ...children);
fn Node* div(Node*... children)   => c3mponents::el("div", ...children);
fn Node* dl(Node*... children)    => c3mponents::el("dl", ...children);
fn Node* dt(Node*... children)    => c3mponents::el("dt", ...children);
fn Node* figcaption(Node*... children) => c3mponents::el("figcaption", ...children);
fn Node* figure(Node*... children) => c3mponents::el("figure", ...children);
fn Node* hr(Node*... children)    => c3mponents::el("hr", ...children);
fn Node* li(Node*... children)    => c3mponents::el("li", ...children);
fn Node* menu(Node*... children)  => c3mponents::el("menu", ...children);
fn Node* ol(Node*... children)    => c3mponents::el("ol", ...children);
fn Node* p(Node*... children)     => c3mponents::el("p", ...children);
fn Node* pre(Node*... children)   => c3mponents::el("pre", ...children);
fn Node* ul(Node*... children)    => c3mponents::el("ul", ...children);

// ── Text-level semantics ──────────────────────────────────────────────────────

fn Node* a(Node*... children)     => c3mponents::el("a", ...children);
fn Node* abbr(Node*... children)  => c3mponents::el("abbr", ...children);
fn Node* b(Node*... children)     => c3mponents::el("b", ...children);
fn Node* bdi(Node*... children)   => c3mponents::el("bdi", ...children);
fn Node* bdo(Node*... children)   => c3mponents::el("bdo", ...children);
fn Node* br(Node*... children)    => c3mponents::el("br", ...children);
fn Node* cite(Node*... children)  => c3mponents::el("cite", ...children);
fn Node* code(Node*... children)  => c3mponents::el("code", ...children);
fn Node* data_el(Node*... children) => c3mponents::el("data", ...children);
fn Node* dfn(Node*... children)   => c3mponents::el("dfn", ...children);
fn Node* em(Node*... children)    => c3mponents::el("em", ...children);
fn Node* i(Node*... children)     => c3mponents::el("i", ...children);
fn Node* kbd(Node*... children)   => c3mponents::el("kbd", ...children);
fn Node* mark(Node*... children)  => c3mponents::el("mark", ...children);
fn Node* q(Node*... children)     => c3mponents::el("q", ...children);
fn Node* rp(Node*... children)    => c3mponents::el("rp", ...children);
fn Node* rt(Node*... children)    => c3mponents::el("rt", ...children);
fn Node* ruby(Node*... children)  => c3mponents::el("ruby", ...children);
fn Node* s(Node*... children)     => c3mponents::el("s", ...children);
fn Node* samp(Node*... children)  => c3mponents::el("samp", ...children);
fn Node* small(Node*... children) => c3mponents::el("small", ...children);
fn Node* span(Node*... children)  => c3mponents::el("span", ...children);
fn Node* strong(Node*... children) => c3mponents::el("strong", ...children);
fn Node* sub(Node*... children)   => c3mponents::el("sub", ...children);
fn Node* sup(Node*... children)   => c3mponents::el("sup", ...children);
fn Node* time_el(Node*... children) => c3mponents::el("time", ...children);
fn Node* u(Node*... children)     => c3mponents::el("u", ...children);
fn Node* var_el(Node*... children) => c3mponents::el("var", ...children);
fn Node* wbr(Node*... children)   => c3mponents::el("wbr", ...children);

// ── Edits ─────────────────────────────────────────────────────────────────────

fn Node* del(Node*... children) => c3mponents::el("del", ...children);
fn Node* ins(Node*... children) => c3mponents::el("ins", ...children);

// ── Embedded content ──────────────────────────────────────────────────────────

fn Node* audio(Node*... children)   => c3mponents::el("audio", ...children);
fn Node* canvas(Node*... children)  => c3mponents::el("canvas", ...children);
fn Node* embed(Node*... children)   => c3mponents::el("embed", ...children);
fn Node* iframe(Node*... children)  => c3mponents::el("iframe", ...children);
fn Node* img(Node*... children)     => c3mponents::el("img", ...children);
fn Node* object_el(Node*... children) => c3mponents::el("object", ...children);
fn Node* picture(Node*... children) => c3mponents::el("picture", ...children);
fn Node* source(Node*... children)  => c3mponents::el("source", ...children);
fn Node* svg(Node*... children)     => c3mponents::el("svg", ...children);
fn Node* track(Node*... children)   => c3mponents::el("track", ...children);
fn Node* video(Node*... children)   => c3mponents::el("video", ...children);

// ── Tables ────────────────────────────────────────────────────────────────────

fn Node* caption(Node*... children)  => c3mponents::el("caption", ...children);
fn Node* col(Node*... children)      => c3mponents::el("col", ...children);
fn Node* colgroup(Node*... children) => c3mponents::el("colgroup", ...children);
fn Node* table(Node*... children)    => c3mponents::el("table", ...children);
fn Node* tbody(Node*... children)    => c3mponents::el("tbody", ...children);
fn Node* td(Node*... children)       => c3mponents::el("td", ...children);
fn Node* template_el(Node*... children) => c3mponents::el("template", ...children);
fn Node* tfoot(Node*... children)    => c3mponents::el("tfoot", ...children);
fn Node* th(Node*... children)       => c3mponents::el("th", ...children);
fn Node* thead(Node*... children)    => c3mponents::el("thead", ...children);
fn Node* tr(Node*... children)       => c3mponents::el("tr", ...children);

// ── Forms ─────────────────────────────────────────────────────────────────────

fn Node* button(Node*... children)   => c3mponents::el("button", ...children);
fn Node* datalist(Node*... children) => c3mponents::el("datalist", ...children);
fn Node* details(Node*... children)  => c3mponents::el("details", ...children);
fn Node* dialog(Node*... children)   => c3mponents::el("dialog", ...children);
fn Node* fieldset(Node*... children) => c3mponents::el("fieldset", ...children);
fn Node* form(Node*... children)     => c3mponents::el("form", ...children);
fn Node* input(Node*... children)    => c3mponents::el("input", ...children);
fn Node* label(Node*... children)    => c3mponents::el("label", ...children);
fn Node* legend(Node*... children)   => c3mponents::el("legend", ...children);
fn Node* meter(Node*... children)    => c3mponents::el("meter", ...children);
fn Node* optgroup(Node*... children) => c3mponents::el("optgroup", ...children);
fn Node* option(Node*... children)   => c3mponents::el("option", ...children);
fn Node* output(Node*... children)   => c3mponents::el("output", ...children);
fn Node* progress(Node*... children) => c3mponents::el("progress", ...children);
fn Node* select_el(Node*... children) => c3mponents::el("select", ...children);
fn Node* slot_el(Node*... children)  => c3mponents::el("slot", ...children);
fn Node* summary(Node*... children)  => c3mponents::el("summary", ...children);
fn Node* textarea(Node*... children) => c3mponents::el("textarea", ...children);
