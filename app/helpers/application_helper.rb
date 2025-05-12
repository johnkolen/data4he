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

  def ov_fields_for oattr, &block
    hold = @ov_form
    out = []
    @ov_form.fields_for oattr do |form|
      hold_obj = @ov_obj
      @ov_form = form
      @ov_obj = form.object
      out << capture(&block)
    end
    @ov_form = hold
    out.join.html_safe
  end
end
