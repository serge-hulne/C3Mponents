// Example demonstrating the c3mponents HTML generator library.
// Shows how to build HTML documents programmatically in pure C3.
module example;

import std::io;
import std::core::dstring;
import c3mponents;
import c3mponents::html;
import c3mponents::components;

// navbar builds a navigation bar.
// The current_path argument is used to mark the active link.
fn Node* navbar(String current_path)
{
    return html::nav(
        html::class_attr("navbar"),
        components::nav_link("/",       "Home",    current_path),
        components::nav_link("/about",  "About",   current_path),
        components::nav_link("/blog",   "Blog",    current_path),
    );
}

// product_card builds a card component for a product.
fn Node* product_card(String title, String price, String img_src)
{
    return html::div(
        html::class_attr("card"),
        html::img(
            html::src(img_src),
            html::alt(title),
            html::class_attr("card-img"),
        ),
        html::div(
            html::class_attr("card-body"),
            html::h3(c3mponents::text(title)),
            html::p(
                html::class_attr("price"),
                c3mponents::text(price),
            ),
            html::a(
                html::href("/buy"),
                html::class_attr("btn btn-primary"),
                c3mponents::text("Buy Now"),
            ),
        ),
    );
}

// product_list builds a grid of product cards.
fn Node* product_list()
{
    return html::div(
        html::class_attr("product-grid"),
        product_card("Widget A", "$9.99",  "/img/widget-a.jpg"),
        product_card("Widget B", "$14.99", "/img/widget-b.jpg"),
        product_card("Widget C", "$24.99", "/img/widget-c.jpg"),
    );
}

// home_page builds a complete home page.
fn Node* home_page(String current_path)
{
    return components::html5({
        .title       = "My Shop",
        .description = "The best widgets on the internet.",
        .language    = "en",
        .head        = {
            html::link(
                html::rel("stylesheet"),
                html::href("/styles.css"),
            ),
        },
        .body        = {
            navbar(current_path),
            html::main_el(
                html::class_attr("container"),
                html::section(
                    html::h1(c3mponents::text("Welcome to My Shop")),
                    html::p(c3mponents::text("Browse our curated selection of widgets.")),
                ),
                html::section(
                    html::class_attr("products"),
                    html::h2(c3mponents::text("Featured Products")),
                    product_list(),
                ),
            ),
            html::footer(
                html::p(c3mponents::text("© 2025 My Shop. All rights reserved.")),
            ),
        },
    });
}

// simple_form demonstrates form elements.
fn Node* simple_form()
{
    return html::form(
        html::action("/submit"),
        html::method("post"),
        html::div(
            html::class_attr("field"),
            html::label(
                html::for_attr("username"),
                c3mponents::text("Username"),
            ),
            html::input(
                html::id("username"),
                html::name("username"),
                html::type_attr("text"),
                html::placeholder("Enter your username"),
                html::required(),
            ),
        ),
        html::div(
            html::class_attr("field"),
            html::label(
                html::for_attr("email"),
                c3mponents::text("Email"),
            ),
            html::input(
                html::id("email"),
                html::name("email"),
                html::type_attr("email"),
                html::placeholder("you@example.com"),
                html::required(),
            ),
        ),
        html::div(
            html::class_attr("field"),
            html::label(
                html::for_attr("message"),
                c3mponents::text("Message"),
            ),
            html::textarea(
                html::id("message"),
                html::name("message"),
                html::rows("5"),
                html::placeholder("Your message..."),
            ),
        ),
        html::button(
            html::type_attr("submit"),
            html::class_attr("btn btn-primary"),
            c3mponents::text("Send"),
        ),
    );
}

// render renders a node to a string within a temp pool.
fn String render(Node* node)
{
    DString buf;
    buf.tinit(4096);
    node.render(&buf);
    return buf.str_view();
}

fn void main()
{
    @pool()
    {
        io::printn("=== Home Page ===");
        String page_html = render(home_page("/"));
        io::printn(page_html);

        io::printn("\n=== Contact Form ===");
        String form_html = render(simple_form());
        io::printn(form_html);

        // Demonstrate HTML escaping
        io::printn("\n=== HTML Escaping ===");
        Node* escaped = html::p(
            c3mponents::text("Safe: <script>alert('xss')</script>"),
        );
        io::printn(render(escaped));

        // Demonstrate raw content
        Node* raw_node = html::p(
            c3mponents::raw("<strong>bold</strong> and <em>italic</em>"),
        );
        io::printn(render(raw_node));

        // Demonstrate conditional rendering
        io::printn("\n=== Conditional Rendering ===");
        bool show_admin = false;
        Node* nav_node = html::nav(
            html::class_attr("menu"),
            components::nav_link("/", "Home", "/"),
            c3mponents::if_node(show_admin, html::a(
                html::href("/admin"),
                c3mponents::text("Admin"),
            )),
            components::nav_link("/about", "About", "/"),
        );
        io::printn(render(nav_node));

        // Demonstrate data and aria attributes
        io::printn("\n=== Data & ARIA Attributes ===");
        Node* accessible_btn = html::button(
            html::type_attr("button"),
            html::class_attr("btn"),
            html::aria("label", "Close dialog"),
            html::aria("expanded", "false"),
            html::data_attr("dialog-id", "modal-1"),
            c3mponents::text("Close"),
        );
        io::printn(render(accessible_btn));

        // Demonstrate group usage
        io::printn("\n=== Groups ===");
        Node* shared_attrs = c3mponents::group(
            html::class_attr("list-item"),
            html::role("listitem"),
        );
        Node* grp_list = html::ul(
            html::li(shared_attrs, c3mponents::text("Item 1")),
            html::li(shared_attrs, c3mponents::text("Item 2")),
            html::li(shared_attrs, c3mponents::text("Item 3")),
        );
        io::printn(render(grp_list));
    };
}
