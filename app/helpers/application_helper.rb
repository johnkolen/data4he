module ApplicationHelper
  def doit
    "doit"
  end
  def object_view obj
    @ov_obj = obj
  end

  def ov_form obj = nil
    @ov_obj = obj || @ov_obj
    f = form_with(model: @ov_obj, class:'ov-form') do |form|
      @ov_form = form
      yield
    end
    tag.div f, class:'form-wrapper'
  end

  def ov_text_field oattr
    id = oattr
    tag.div(class:"mb-3") do
      [tag.label(@ov_obj.send("#{oattr}_label"),
                 for: id,
                 class:"form-label"),
       tag.input(type: :text,
                 class: "form-control",
                 id: id)
      ].join.html_safe
    end
  end
  def ov_submit label = 'Submit'
    tag.button label, type: submit, class: 'btn btn-primary'
  end
end
