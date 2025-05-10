require "action_view"

class ViewBase
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::TagHelper
  include ActionDispatch::Routing::PolymorphicRoutes
  def initialize obj
    @obj = obj
  end
  def form
    form_with(model: @obj) do |form|
      @form = form
      yield
    end
  end
  def msg
    "hello"
  end
end

module People
  class View < ViewBase
    def text attr, lbl
      tag.div(class:"mb-3") do
        [tag.label(lbl, for: attr, class:"form-label"),
         tag.input(type: :text,
                   class: "form-control",
                   id: attr,
                   :"aria-describedby" => attr),
        ].join
      end
    end
  end
end
