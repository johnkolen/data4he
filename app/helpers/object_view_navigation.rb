module ObjectViewNavigation
  def user_list_dropdown
    tag.li class: "nav-item dropdown" do
      [ tag.a("Switch User",
              href: "#",
              role: "button",
              class: "nav-link dropdown-toggle",
              aria: { expanded: "false"},
              data: { "bs-toggle": "dropdown"}),
        tag.ul(class: "dropdown-menu") do
          User.all.map do |u|
            tag.li(link_to(u.email, user_switch_path(u), href: "#", class: "dropdown-item"))
          end.join.html_safe
        end
      ].join.html_safe
    end
  end


  def navigation(**options, &block)
    brand = options.delete(:_brand)
    tag.nav class: "navbar navbar-expand-lg navbar-light bg-light" do
      tag.div class: "container-fluid" do
        v1 = link_to(brand, root_path, class: "navbar-brand")
        v2 = tag.div(class: "collase navbar-collapse") do
          tag.ul class: "nav" do
            lis =
              options.map do |label, path|
              case path
              when String
                tag.li(button_to(label,
                                 path,
                                 method: :get,
                                 class: "nav-link active"))
              when Hash
                tag.li(button_to(label,
                                 path[:path],
                                 method: path[:method] || :get,
                                 class: path[:class] || "nav-link active"))
              end
            end
            lis << user_list_dropdown
            lis.join.html_safe
          end
        end
        email = user_signed_in? ? current_user.email : nil
        v3 = tag.div email, class: "ov-nav-username"

        (v1 + v2 + v3).html_safe
      end
    end
  end
end
