// Package c3mponents provides HTML node types and rendering logic.
// It works like Go's Gomponents library: nodes are composed into trees
// and rendered to HTML strings.
//
// All allocations use the temp allocator; wrap usage in @pool() for
// automatic memory management:
//
//   @pool() {
//       Node* page = html::html_el(html::head(...), html::body(...));
//       DString buf;
//       buf.tinit(4096);
//       page.render(&buf);
//       io::printn(buf.str_view());
//   };
module c3mponents;

import std::core::dstring;

// NodeKind distinguishes what kind of data a Node holds.
enum NodeKind : char
{
    ELEM,       // HTML element, e.g. <div class="foo">...</div>
    ATTR,       // HTML attribute with value, e.g. class="foo"
    ATTR_BOOL,  // Boolean HTML attribute (no value), e.g. required
    TEXT,       // HTML-escaped text content
    RAW,        // Unescaped raw content
    GROUP,      // Collection of nodes (transparent wrapper)
    DOCTYPE,    // Renders <!doctype html> followed by first child
    NONE        // Null/empty node (used for conditional rendering)
}

// Node is the fundamental building block of the HTML tree.
// All nodes are heap-allocated and meant to be used within a @pool() scope.
struct Node
{
    NodeKind kind;
    String   name;     // Tag name (ELEM) or attribute name (ATTR, ATTR_BOOL)
    String   content;  // Text content (TEXT, RAW) or attribute value (ATTR)
    Node*[]  children; // Child nodes (ELEM, GROUP, DOCTYPE)
}

// render writes this node as HTML to buf.
fn void Node.render(Node* self, DString* buf)
{
    if (self == null || self.kind == NONE) return;

    switch (self.kind)
    {
        case ELEM:
            buf.append_char('<');
            buf.append_chars(self.name);
            // First pass: write attribute-type children inside the opening tag
            foreach (child : self.children)
            {
                if (child != null) child.render_as(buf, true);
            }
            buf.append_char('>');
            if (!is_void_element(self.name))
            {
                // Second pass: write element-type children
                foreach (child : self.children)
                {
                    if (child != null) child.render_as(buf, false);
                }
                buf.append_chars("</");
                buf.append_chars(self.name);
                buf.append_char('>');
            }

        case ATTR:
            buf.append_char(' ');
            buf.append_chars(self.name);
            buf.append_chars("=\"");
            html_escape(self.content, buf);
            buf.append_char('"');

        case ATTR_BOOL:
            buf.append_char(' ');
            buf.append_chars(self.name);

        case TEXT:
            html_escape(self.content, buf);

        case RAW:
            buf.append_chars(self.content);

        case GROUP:
            // Groups expand transparently, skipping bare attributes
            foreach (child : self.children)
            {
                if (child != null) child.render_as(buf, false);
            }

        case DOCTYPE:
            buf.append_chars("<!doctype html>");
            if (self.children.len > 0 && self.children[0] != null)
            {
                self.children[0].render(buf);
            }

        case NONE:
            // nothing
    }
}

// render_as writes this node only if it matches the desired rendering context:
//   attr_context=true  → only attribute-type nodes are rendered
//   attr_context=false → only element-type nodes are rendered
// GROUP nodes are expanded transparently in either context.
fn void Node.render_as(Node* self, DString* buf, bool attr_context)
{
    if (self == null || self.kind == NONE) return;

    // Groups are expanded in-place so attributes inside groups are visible
    if (self.kind == GROUP)
    {
        foreach (child : self.children)
        {
            if (child != null) child.render_as(buf, attr_context);
        }
        return;
    }

    bool is_attr = self.kind == ATTR || self.kind == ATTR_BOOL;
    if (attr_context == is_attr) self.render(buf);
}

// to_string renders this node to a temp-allocated String.
fn String Node.to_string(Node* self)
{
    DString buf;
    buf.tinit(256);
    self.render(&buf);
    return buf.str_view();
}

// html_escape appends s to buf with HTML special characters escaped.
fn void html_escape(String s, DString* buf)
{
    foreach (c : s)
    {
        switch (c)
        {
            case '&':  buf.append_chars("&amp;");
            case '<':  buf.append_chars("&lt;");
            case '>':  buf.append_chars("&gt;");
            case '"':  buf.append_chars("&#34;");
            case '\'': buf.append_chars("&#39;");
            default:   buf.append_char(c);
        }
    }
}

// is_void_element returns true for HTML void elements (no closing tag).
// See https://dev.w3.org/html5/spec-LC/syntax.html#void-elements
fn bool is_void_element(String name)
{
    switch (name)
    {
        case "area":    return true;
        case "base":    return true;
        case "br":      return true;
        case "col":     return true;
        case "command": return true;
        case "embed":   return true;
        case "hr":      return true;
        case "img":     return true;
        case "input":   return true;
        case "keygen":  return true;
        case "link":    return true;
        case "meta":    return true;
        case "param":   return true;
        case "source":  return true;
        case "track":   return true;
        case "wbr":     return true;
        default:        return false;
    }
}
