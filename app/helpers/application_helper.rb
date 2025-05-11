module ApplicationHelper
  def object_view obj
    @ov_obj = obj
  end

  def ov_form obj = nil
    @ov_obj = obj || @ov_obj
    f = form_with(model: @ov_obj,
                  class: 'ov-form') do |form|
      @ov_form = form
      yield
    end
    tag.div f, class: 'ov-form-wrapper'
  end

  def ov_display obj = nil
    return ""
    @ov_obj = obj || @ov_obj
    tag.div yield, id: dom_id(@ov_obj), class: 'ov-display'
  end

  def ov_text_field oattr
    id = oattr
    tag.div(class:"mb-3") do
      [tag.label(@ov_obj.send("#{oattr}_label"),
                 for: id,
                 class:"form-label"),
       @ov_form ?
         @ov_form.text_field(oattr,
                             class: "form-control",
                             id: id) :
         tag.div( @ov_obj.send("#{oattr}"), class: "ov-text")
      ].join.html_safe
    end
  end

  def ov_date_field oattr
    id = oattr
    tag.div(class:"mb-3") do
      [tag.label(@ov_obj.send("#{oattr}_label"),
                 for: id,
                 class:"form-label"),
       @ov_form ?
         @ov_form.date_field(class: "form-control", id: id) :
         tag.div( @ov_obj.send("#{oattr}"), class: "ov-text")
      ].join.html_safe
    end
  end

  def ov_submit label = 'Submit'
    tag.button label, type: :submit, class: 'btn btn-primary'
  end

  def ov_table_row obj = nil
    @ov_obj = obj || @ov_obj
    tag.tr "<td>data</td>".html_safe, id: dom_id(@ov_obj), class: 'ov-table-row'
    #"<tr><td>data</td><tr>"
  end

  def ov_col oattr
    tag.td( @ov_obj.send("#{oattr}"), class: "ov-table-col")
  end
end
