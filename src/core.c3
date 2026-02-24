// Core constructor functions for building HTML node trees.
// All functions allocate using the temp allocator and are designed
// to be used within a @pool() scope.
module c3mponents;

import std::core::mem;

// el creates an HTML element node with the given tag name and children.
// Children may be a mix of attribute nodes and element/text nodes.
// The renderer automatically sorts them into the correct positions.
//
// Example:
//   el("div", attr("class", "container"), text("Hello"))
//   → <div class="container">Hello</div>
fn Node* el(String tag, Node*... children)
{
    Node* node = mem::tnew(Node);
    node.kind  = ELEM;
    node.name  = tag;
    if (children.len > 0)
    {
        Node*[] arr = mem::talloc_array(Node*, children.len);
        foreach (i, child : children) arr[i] = child;
        node.children = arr;
    }
    return node;
}

// attr creates an HTML attribute node with a name and value.
//
// Example:
//   attr("class", "container")  → class="container"
fn Node* attr(String name, String value)
{
    Node* node   = mem::tnew(Node);
    node.kind    = ATTR;
    node.name    = name;
    node.content = value;
    return node;
}

// bool_attr creates a boolean HTML attribute node (no value).
// Used for attributes like required, disabled, checked, readonly.
//
// Example:
//   bool_attr("required")  → required
fn Node* bool_attr(String name)
{
    Node* node = mem::tnew(Node);
    node.kind  = ATTR_BOOL;
    node.name  = name;
    return node;
}

// text creates an HTML-escaped text node.
// Special characters (&, <, >, ", ') are escaped automatically.
//
// Example:
//   text("Hello <World>")  → Hello &lt;World&gt;
fn Node* text(String t)
{
    Node* node   = mem::tnew(Node);
    node.kind    = TEXT;
    node.content = t;
    return node;
}

// textf creates an HTML-escaped text node from a formatted string.
// The formatted string is allocated on the temp allocator.
//
// Example:
//   textf("Hello, %s!", name)  → Hello, Name! (escaped)
fn Node* textf(String fmt, args...)
{
    DString s;
    (void)s.appendf(fmt, ...args);
    return text(s.str_view());
}

// raw creates a raw (unescaped) text node.
// Use this for trusted HTML content like inline scripts or styles.
//
// Example:
//   raw("<strong>bold</strong>")  → <strong>bold</strong>
fn Node* raw(String t)
{
    Node* node   = mem::tnew(Node);
    node.kind    = RAW;
    node.content = t;
    return node;
}

// group creates a transparent wrapper around multiple nodes.
// Groups are expanded in-place during rendering, so attribute nodes
// inside a group are still rendered in the parent element's opening tag.
//
// Example:
//   group(attr("class", "foo"), text("Hello"))
fn Node* group(Node*... children)
{
    Node* node = mem::tnew(Node);
    node.kind  = GROUP;
    if (children.len > 0)
    {
        Node*[] arr = mem::talloc_array(Node*, children.len);
        foreach (i, child : children) arr[i] = child;
        node.children = arr;
    }
    return node;
}

// if_node returns node when condition is true, otherwise returns null.
// Null nodes are silently skipped during rendering.
//
// Example:
//   if_node(user.is_admin, admin_link())
fn Node* if_node(bool condition, Node* n)
{
    if (condition) return n;
    return null;
}

// doctype creates a DOCTYPE node that renders <!doctype html> followed
// by the given sibling node.
//
// Example:
//   doctype(html_el(...))  → <!doctype html><html>...</html>
fn Node* doctype(Node* sibling)
{
    Node* node    = mem::tnew(Node);
    node.kind     = DOCTYPE;
    node.children = mem::talloc_array(Node*, 1);
    node.children[0] = sibling;
    return node;
}
