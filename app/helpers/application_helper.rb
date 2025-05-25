require "active_support/inflector"

module ApplicationHelper
  include ObjectViewButtons
  include ObjectViewNavigation
  include ObjectViewTable
  include ObjectViewModal

  def object_view(obj)
    @ov_obj = obj
  end

  def ov_form(obj = nil, **options, &block)
    Access.allow? obj, :edit do
      @ov_access = :edit
      @ov_obj = obj || @ov_obj
      p = {}
      if options[:turbo]
        p = { tf: 1 }
      end
      f = form_with(model: @ov_obj,
                    url: polymorphic_path(@ov_obj, params: p),
                    class: "ov-form",
                    **options) do |form|
        @ov_form = form
        capture &block
      end
      tag.div f, class: "ov-form-wrapper"
    end
  end

  def ov_display(obj = nil, &block)
    Access.allow? obj, :view do
      @ov_access = :view
      return capture &block if @ov_form
      @ov_obj = obj || @ov_obj
      content = capture &block
      tag.div content, id: dom_id(@ov_obj), class: "ov-display"
    end
  end

  def ov_text_field(oattr, **options)
    return unless Access.allow? oattr, @ov_access
    return ov_col(oattr, **options) if @ov_table_row
    return if @ov_obj.is_a? Array
    id = oattr
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

  def ov_submit(label = "Submit")
    return unless Access.allow? @ov_obj, @ov_access
    tag.button label, type: :submit, class: "btn btn-primary"
  end

  def ov_with(oattr, &block)
    hold = @ov_obj
    @ov_obj =
      if @ov_obj.is_a? Array
        [ @ov_obj.first.send(oattr) ]
      else
        @ov_obj.send(oattr)
      end
    res = capture &block
    @ov_obj = hold
    res
  end

  def ov_errors
    return nil unless @ov_obj && @ov_obj.errors.any?
    tag.div class: "alert alert-danger ov-error" do
      out = [ tag.h2("#{pluralize(@ov_obj.errors.count, "error")} " +
                     "prohibited this " +
                     @ov_obj.class.to_s.downcase +
                     "from being saved:",
                     class: "ov-error-header"), "<ul>" ]
      @ov_obj.errors.each do |error|
        out << tag.li(error.full_message, class: "ov-error-item")
      end
      out << "</ul>"
      out.join.html_safe
    end.html_safe
  end

  def _get_objects(oattr)
    hold = @ov_obj
    if ov_one_to_one? oattr
      @ov_obj = @ov_obj.send(oattr)
      elems = [ render(partial: "#{oattr.to_s.pluralize}/#{oattr}",
                       locals: { oattr => @ov_obj }) ]
    else
      elems = @ov_obj.send(oattr).map do |obj|
        @ov_obj = obj
        render "#{oattr}/#{oattr}"
      end.map do |x|
        tag.li x, class: "ov-object"
      end
    end
    @ov_obj = hold
    elems.join.html_safe
  end

  def ov_fields_for_view(oattr)
    if ov_one_to_one? oattr
    end
    elems = _get_objects oattr

    str = tag.div class: "ov-field" do
      [ tag.label(@ov_obj.send("#{oattr}_label"),
                  for: oattr,
                  class: @ov_form ? "form-label" : "ov-label"),
        tag.ul(elems, class: "ov-fields-for")
      ].join.html_safe
    end
    str.html_safe
  end

  def set_ov_obj(obj)
    @ov_obj = obj
  end

  def ov_one_to_one?(oattr)
    r = @ov_obj.class.reflect_on_association(oattr)
    r.macro == :belongs_to && r.inverse_of.macro == :has_one
  end

  def ov_fields_for(oattr, **options, &block)
    if options[:if] == :exists
      return nil unless @ov_obj.send(oattr)
    end
    return ov_fields_for_view oattr unless @ov_form
    hold = [ @ov_form, @ov_obj, @ov_elem ]
    out = []

    one2one = ov_one_to_one?(oattr)
    unless one2one
      # only show add button and construct a list
      # for one-to-many or many-to-many relationships
      out << '<ul class="ov-fields-for" data-ov-fields-for-target="list">'
      out << ov_add
    end

    name = @ov_obj.class.to_s.underscore
    elem_num = 0
    @ov_form.fields_for oattr, @ov_obj.send(oattr) do |form|
      @ov_form = form
      @ov_obj = form.object
      elem_num += 1
      li_id = "#{name}-li-#{elem_num}"
      # include object"s id  if it's been persisted
      pid = @ov_obj.persisted? ? @ov_form.hidden_field(:id) : ""
      fields = block_given? ? capture(&block) :
                 render("#{oattr.to_s.pluralize}/#{oattr}", oattr=>@ov_obj)
      li_body = pid + fields
      li_body += ov_remove(li_id) unless one2one
      elem = tag.li(li_body.html_safe,
                    id: li_id,
                    class: "ov-object collapse show").html_safe
      if !one2one && @ov_obj.new_record?
        out << tag.template(elem,
                            id: "ov-#{name}-template",
                            data: { "ov-fields-for-target": "template" })
      else
        out << elem
      end
    end
    unless one2one
      out << "</ul>"
    end

    str = tag.div class: "ov-field",
                  data: { controller: "ov-fields-for" } do
      # only show label for one-to-many or many-to-many
      [ one2one ? "" :
          tag.label(hold[1].send("#{oattr}_label"),
                    for: oattr,
                    class: @ov_form ? "form-label" : "ov-label"),
        out.join.html_safe
      ].join.html_safe
    end
    @ov_form, @ov_obj, @ov_elem = hold
    str.html_safe
  end
end
