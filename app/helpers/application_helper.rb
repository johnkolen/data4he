module ApplicationHelper
  def object_view obj
    @ov_obj = obj
  end

  def ov_form obj = nil, &block
    @ov_obj = obj || @ov_obj
    f = form_with(model: @ov_obj,
                  class: 'ov-form') do |form|
      @ov_form = form
      capture &block
    end
    tag.div f, class: 'ov-form-wrapper'
  end

  def ov_display obj = nil, &block
    @ov_obj = obj || @ov_obj
    content = capture &block

    tag.div content, id: dom_id(@ov_obj), class: 'ov-display'
  end

  def ov_text_field oattr
    id = oattr
    tag.div(class:"ov-field") do
      [tag.label(@ov_obj.send("#{oattr}_label"),
                 for: id,
                 class:@ov_form ? "form-label" : "ov-label"),
       @ov_form ?
         @ov_form.text_field(oattr,
                             class: "form-control",
                             pattern: @ov_obj.send("#{oattr}_pattern"),
                             id: id) :
         tag.div( @ov_obj.send("#{oattr}"), class: "ov-text")
      ].join.html_safe
    end
  end

  def ov_checkbox oattr
    id = oattr
    cb_class = "form-check-input ov-checkbox"
    tag.div(class:"ov-field") do
      [@ov_form ?
         @ov_form.checkbox(oattr,
                           class: cb_class,
                           id: id) :
         tag.div(tag.input(type: 'checkbox',
                   checked: @ov_obj.send("#{oattr}"),
                   onclick: "return false",
                   class: cb_class), class:"ov-checkbok-holder"),
       tag.label(@ov_obj.send("#{oattr}_label"),
                 for: id,
                 class: @ov_form ? "form-check-label" : "ov-checkbox-label")
      ].join.html_safe
    end
  end

  # In progress
  def ov_radio oattr, radio_name=nil
    id = oattr
    radio_name = "radio-#{radio_name ||= oattr}"
    cb_class = "form-check-input ov-checkbox"
    tag.div(class:"ov-field") do
      [@ov_form ?
         @ov_form.radio_button(oattr,
                               class: cb_class,
                               name: radio_name,
                               id: id) :
         tag.input('',
                   value: @ov_obj.send("#{oattr}") ? 'true' : 'false',
                   checked: @ov_obj.send("#{oattr}") ? 'checked' : nil,
                   type: 'radio',
                   class: cb_class),
       tag.label(@ov_obj.send("#{oattr}_label"),
                 for: id,
                 class: "form-check-label")
      ].join.html_safe
    end
  end

  def ov_date_field oattr
    id = oattr
    tag.div(class:"ov-field") do
      [tag.label(@ov_obj.send("#{oattr}_label"),
                 for: id,
                 class:@ov_form ? "form-label" : "ov-label"),
       @ov_form ?
         @ov_form.date_field(oattr, class: "form-control", id: id) :
         tag.div( @ov_obj.send("#{oattr}_str"), class: "ov-text")
      ].join.html_safe
    end
  end

  def ov_submit label = 'Submit'
    tag.button label, type: :submit, class: 'btn btn-primary'
  end

  def ov_table klass, objs = []
    sym = klass.to_s.downcase.to_sym
    content = [
      render(partial: "table_row",
             locals: {sym => [klass.new]})
    ]
    objs.each do |obj|
      content << render(partial: "table_row", locals:{sym => obj})
    end
    tag.table content.join.html_safe,
              id: "#{klass.to_s.downcase}_table",
              class: 'ov-display'
  end

  def ov_table_row obj = nil, &block
    @ov_obj = obj || @ov_obj
    content = capture &block
    if @ov_obj.is_a? Array
      tag.tr content.html_safe,  class: 'ov-table-row-head'
    else
      tag.tr content.html_safe, id: dom_id(@ov_obj), class: 'ov-table-row'
    end
  end

  def ov_col oattr
    if @ov_obj.is_a? Array
      tag.td( @ov_obj.first.send("#{oattr}_label"), class: "ov-table-hdr")
    else
      tag.td( @ov_obj.send("#{oattr}"), class: "ov-table-col")
    end
  end

  def ov_show obj=nil
    obj ||= @ov_obj
    return if obj.is_a? Array
    #edit_person_path(@ov_obj)
    b=button_to "Show", polymorphic_path(obj),
                :method=>:get,
                class: "btn btn-primary"
    tag.td(b, class: "ov-table-col-button")

  end

  def ov_edit obj=nil
    obj ||= @ov_obj
    return if obj.is_a? Array
    #edit_person_path(@ov_obj)
    b=button_to "Edit", edit_polymorphic_path(obj),
                :method=>:get,
                class: "btn btn-primary"
    tag.td(b, class: "ov-table-col-button")

  end

  def ov_delete obj=nil
    obj ||= @ov_obj
    return if obj.is_a? Array
    #edit_person_path(@ov_obj)
    b=button_to "Delete",
                polymorphic_path(obj),
                :method=>:delete,
                form: { data: { turbo_confirm: 'Are you sure?' } },
                class: "btn btn-danger"
    tag.td(b, class: "ov-table-col-button")

  end

  def ov_new klass
    return if klass.is_a? Array
    #edit_person_path(@ov_obj)
    button_to "New", new_polymorphic_path(klass),
                :method=>:get,
                class: "btn btn-primary"
  end

  def ov_index klass
    #edit_person_path(@ov_obj)
    button_to klass.to_s.pluralize,
                polymorphic_path(klass),
                :method=>:get,
                class: "btn btn-primary"
  end

  def ov_add
    button_class = [
      "add-btn",
      "add-#{@ov_obj.class.to_s.downcase}-btn",
      "btn btn-primary"
    ].join ' '
    @ov_new_record_found ||= @ov_obj.new_record?
    tag.button 'Add',
               class: button_class,
               type: 'button',
               data: {action: "click->ov-fields-for#add"}
  end

  def ov_remove
    button_class = [
      "remove-btn",
      "remove-#{@ov_obj.class.to_s.downcase}-btn",
      "btn btn-primary"
    ].join ' '
    tag.button 'Remove',
               class: button_class,
               type: 'button',
               "data-bs-toggle": "collapse",
               "data-bs-target": ".#{@ov_li_id}"
  end

  def ov_errors
    return nil unless @ov_obj && @ov_obj.errors.any?
    tag.div class: "alert alert-danger ov-error" do
      out = [tag.h2("#{pluralize(@ov_obj.errors.count, "error")} " +
                    "prohibited this " +
                    @ov_obj.class.to_s.downcase +
                    "from being saved:",
                    class: 'ov-error-header'), "<ul>"]
      @ov_obj.errors.each do |error|
        out << tag.li(error.full_message, class: 'ov-error-item')
      end
      out << "</ul>"
      out.join.html_safe
    end.html_safe
  end

  def ov_fields_for_view oattr
    hold = @ov_obj
    res = @ov_obj.send(oattr).map do |obj|
      @ov_obj = obj
      render "#{oattr}/#{oattr}"
    end.map do |x|
      tag.li x, class: "ov-field"
    end.join.html_safe
    @ov_obj = hold
    str = tag.div class: 'ov-fields-for' do
      [tag.label(@ov_obj.send("#{oattr}_label"),
                 for: oattr,
                 class:@ov_form ? "form-label" : "ov-label"),
       tag.ul(res)
      ].join.html_safe
    end
    str.html_safe
  end

  def ov_fields_for oattr, &block
    return ov_fields_for_view oattr unless block_given?
    hold = [@ov_form, @ov_obj, @ov_elem, @ov_new_record_found]
    out = []
    @ov_elem = 0
    @ov_new_record_found = false
    name = @ov_obj.class.to_s.downcase
    out << '<ul data-ov-fields-for-target="list">'
    @ov_form.fields_for oattr  do |form|
      @ov_form = form
      @ov_obj = form.object
      @ov_elem += 1
      @ov_li_id = "#{name}-li-#{@ov_elem}"
      if @ov_obj.new_record?
        tmp = tag.template id:"ov-#{name}-template",
                           data:{"ov-fields-for-target": "template"} do
          capture(&block)
        end
        out << tag.div(tmp, class: "hidex")
      else
        out << capture(&block)
      end
    end
    out << '</ul>'
    str = tag.div data:{controller: 'ov-fields-for'} do
      [tag.label(hold[1].send("#{oattr}_label"),
                 for: oattr,
                 class:@ov_form ? "form-label" : "ov-label"),
       ov_add,
       out.join.html_safe].join.html_safe
    end
    @ov_form, @ov_obj, @ov_elem, @ov_new_record_found = hold
    str.html_safe
  end
end
