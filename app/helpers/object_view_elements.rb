module ObjectViewElements
  def ov_text_field(oattr, **options)
    return unless Access.allow? oattr, @ov_access
    return ov_col(oattr, **options) if @ov_table_row
    return if @ov_obj.is_a? Array
    id = oattr
    raise "wtf @ov_obj is nil" if @ov_obj.nil?
    tag.div(class: "ov-field") do
      [ tag.label(@ov_obj.send("#{oattr}_label"),
                  for: id,
                  class: @ov_form ? "form-label" : "ov-label"),
        @ov_form ?
          @ov_form.text_field(oattr,
                              class: "form-control",
                              pattern: @ov_obj.send("#{oattr}_pattern"),
                              id: id,
                              **options) :
          tag.div(@ov_obj.send("#{oattr}"), class: "ov-text")
      ].join.html_safe
    end
  end

  def ov_string_field(oattr, **options)
    ov_text_field oattr, **options
  end

  def ov_integer_field(oattr, **options)
    ov_text_field oattr, **options
  end

  def ov_text_area(oattr, **options)
    return unless Access.allow? oattr, @ov_access
    return ov_col(oattr, **options) if @ov_table_row
    return if @ov_obj.is_a? Array
    id = oattr
    tag.div(class: "ov-field") do
      [ tag.label(@ov_obj.send("#{oattr}_label"),
                  for: id,
                  class: @ov_form ? "form-label" : "ov-label"),
        @ov_form ?
          @ov_form.text_area(oattr,
                             class: "form-control",
                             pattern: @ov_obj.send("#{oattr}_pattern"),
                             id: id,
                             **options) :
          tag.div(@ov_obj.send("#{oattr}"), class: "ov-text")
      ].join.html_safe
    end
  end

  def ov_password_field(oattr, **options)
    return unless Access.allow? oattr, @ov_access
    return ov_col(oattr, **options) if @ov_table_row
    id = oattr
    tag.div(class: "ov-field") do
      [ tag.label(@ov_obj.send("#{oattr}_label"),
                  for: id,
                  class: @ov_form ? "form-label" : "ov-label"),
        @ov_form ?
          @ov_form.password_field(oattr,
                                  class: "form-control",
                                  pattern: @ov_obj.send("#{oattr}_pattern"),
                                  id: id,
                                  **options) :
          tag.div(@ov_obj.send("#{oattr}"), class: "ov-text")
      ].join.html_safe
    end
  end

  def ov_checkbox(oattr, **options)
    return unless Access.allow? oattr, @ov_access
    return ov_col(oattr, **options) if @ov_table_row
    id = oattr
    cb_class = "form-check-input ov-checkbox"
    tag.div(class: "ov-field") do
      [ @ov_form ?
          @ov_form.checkbox(oattr,
                            class: cb_class,
                            id: id) :
          tag.div(tag.input(type: "checkbox",
                            checked: @ov_obj.send("#{oattr}"),
                            onclick: "return false",
                            class: cb_class), class: "ov-checkbok-holder"),
        tag.label(@ov_obj.send("#{oattr}_label"),
                  for: id,
                  class: @ov_form ? "form-check-label" : "ov-checkbox-label")
      ].join.html_safe
    end
  end

  def ov_select(oattr, **options)
    return unless Access.allow? oattr, @ov_access
    return ov_col(oattr, **options) if @ov_table_row
    id = oattr
    s_class = "form-select ov-select"
    mthd = "#{oattr}_id".to_sym
    # raise @ov_form.object.send(mthd).inspect
    # raise @ov_obj.send(mthd).inspect
    opts = options_for_select(@ov_obj.send("#{oattr}_options"),
                              selected: @ov_obj.send(mthd))
    # raise @ov_form.select(mthd,
    #                      opts,
    #                      {},
    #                      { class: s_class }).inspect
    tag.div(class: "ov-field") do
      [ tag.label(@ov_obj.send("#{oattr}_label"),
                  for: id,
                  class: @ov_form ? "form-label" : "ov-label"),
        @ov_form ?
          tag.div(@ov_form.select(mthd,
                                  opts,
                                  {},
                                  { class: s_class }
                                 ), class: "ov-select-holder"):
          tag.div(@ov_obj.send("#{oattr}_str"), class: "ov-text")
      ].join.html_safe
    end
  end

  # In progress
  def ov_radio(oattr, radio_name = nil)
    return unless Access.allow? oattr, @ov_access
    id = oattr
    radio_name = "radio-#{radio_name ||= oattr}"
    cb_class = "form-check-input ov-checkbox"
    tag.div(class: "ov-field") do
      [ @ov_form ?
          @ov_form.radio_button(oattr,
                                class: cb_class,
                                name: radio_name,
                                id: id) :
          tag.input("",
                    value: @ov_obj.send("#{oattr}") ? "true" : "false",
                    checked: @ov_obj.send("#{oattr}") ? "checked" : nil,
                    type: "radio",
                    class: cb_class),
        tag.label(@ov_obj.send("#{oattr}_label"),
                  for: id,
                  class: "form-check-label")
      ].join.html_safe
    end
  end

  def ov_date_field(oattr, **options)
    return unless Access.allow? oattr, @ov_access
    return ov_col(oattr, **options) if @ov_table_row
    id = oattr
    tag.div(class: "ov-field") do
      [ tag.label(@ov_obj.send("#{oattr}_label"),
                  for: id,
                  class: @ov_form ? "form-label" : "ov-label"),
        @ov_form ?
          @ov_form.date_field(oattr, class: "form-control", id: id) :
          tag.div(@ov_obj.send("#{oattr}_str"), class: "ov-text")
      ].join.html_safe
    end
  end

  def ov_datetime_field(oattr, **options)
    return unless Access.allow? oattr, @ov_access
    return ov_col(oattr, **options) if @ov_table_row
    return if @ov_obj.is_a? Array
    id = oattr
    tag.div(class: "ov-field") do
      [ tag.label(@ov_obj.send("#{oattr}_label"),
                  for: id,
                  class: @ov_form ? "form-label" : "ov-label"),
        @ov_form ?
          @ov_form.datetime_field(oattr, class: "form-control", id: id) :
          tag.div(@ov_obj.send("#{oattr}_str"), class: "ov-text")
      ].join.html_safe
    end
  end
end
