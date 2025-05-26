module ObjectViewButtons
  def ov_button_to(label, path, **options)
    button_to label,
              path,
              method: options[:method] || :get,
              form_class: options[:form_class] || "ov-button",
              form: options[:form],
              class: options[:class] || "btn btn-primary"
  end

  def ov_edit(obj = nil, **options)
    obj ||= @ov_obj
    return if obj.is_a? Array
    return unless ov_allow? obj, :edit
    ov_button_to "Edit",
                 options[:path] || edit_polymorphic_path(obj),
                 **options
  end

  def ov_show(obj = nil, **options)
    obj ||= @ov_obj
    return if obj.is_a? Array
    return unless ov_allow? obj, :view
    ov_button_to "Show",
                 polymorphic_path(obj),
                 **options
  end

  def ov_delete(obj = nil, **options)
    obj ||= @ov_obj
    return if obj.is_a? Array
    return unless ov_allow? obj, :delete
    ov_button_to "Delete",
                 polymorphic_path(obj),
                 method: options[:method] || :delete,
                 form: { data: { turbo_confirm: "Are you sure?" } },
                 class: options[:class] || "btn btn-danger"
    end

  def ov_new(klass, **options)
    return unless ov_allow? klass, :create
    return if klass.is_a? Array
    ov_button_to "New",
                 new_polymorphic_path(klass),
                 **options
  end

  def ov_index(klass, **options)
    return unless ov_allow? klass, :index
    ov_button_to klass.to_s.pluralize,
                 polymorphic_path(klass),
                 **options
  end

  def ov_add
    return unless ov_allow? @ov_obj, :edit
    button_class = [
      "add-btn",
      "add-#{ov_obj_class_name_k}-btn",
      "btn btn-primary"
    ].join " "
    @ov_new_record_found ||= @ov_obj.new_record?
    tag.button "Add",
               class: button_class,
               type: "button",
               data: { action: "click->ov-fields-for#add" }
  end

  def ov_remove(id)
    return unless ov_allow? @ov_obj, :edit
    button_class = [
      "remove-btn",
      "remove-#{ov_obj_class_name_k}-btn",
      "btn btn-danger"
    ].join " "
    (@ov_form.hidden_field("_destroy",
                           class: "hdestroy",
                           value: "true").gsub("_destroy", "DESTROY") +
     tag.button("Remove",
                class: button_class,
                type: "button",
                data: { action: "click->ov-fields-for#remove" },
                "data-bs-toggle": "collapse",
                "data-bs-target": "##{id}")).html_safe
  end

  def ov_submit(label = "Submit")
    return unless ov_allow? @ov_obj, @ov_access
    tag.button label, type: :submit, class: "btn btn-primary"
  end
end
