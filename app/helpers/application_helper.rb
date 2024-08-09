# app/helpers/application_helper.rb
module ApplicationHelper
  def breadcrumbs
    crumbs = []
    crumbs << link_to("Home", root_path)

    case controller_name
    when "products"
      crumbs << link_to("Products", products_path)
      crumbs << @product.name if action_name == "show"

    when "categories"
      crumbs << link_to("Categories", categories_path)
      crumbs << @category.name if action_name == "show"

    when "artisans"
      crumbs << link_to("Artisans", artisans_path)
      crumbs << @artisan.name if action_name == "show"

    when "static_pages"
      if action_name == "about"
        crumbs << "About"
      elsif action_name == "contact"
        crumbs << "Contact"
      end

    when "carts"
      crumbs << link_to("View Cart", cart_path)

    when "orders"
      crumbs << link_to("My Orders", orders_path)

    when "registrations"
      crumbs << "Edit Profile" if action_name == "edit"

    when "sessions"
      crumbs << "Login" if action_name == "new"
    end

    crumbs.join(" > ").html_safe
  end
end
