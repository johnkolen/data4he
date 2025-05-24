module ObjectViewModal
  def ov_modal_header **options
    id = options[:id] || "modal"
    tag.div class: "modal-header ov-modal-header" do
      [tag.div(options[:title] || "Title",
               class: "modal-title ov-modal-title", # add fs-5 to css
               id: "#{id}Label"),
       tag.button(type: "button",
                  class: "btn-close",
                  data: {"bs-dismiss": "modal"},
                  aria: {label: "Close"})
      ].join.html_safe
    end
  end

  def ov_modal_body **options, &block
    tag.div class: "modal-body ov-modal-body" do
      if block_given?
        capture &block
      else
        tag.div "Hello"
      end
    end
  end

  def ov_modal_footer **options
    tag.div class: "modal-footer ov-modal-footer" do
      [tag.button("Close",
                  type: "button",
                  class: "btn btn-secondary",
                  data: {"bs-dismiss": "modal"},
                  aria: {label: "Close"}),
       tag.button(type: "button",
                  class: "btn btn-primary") do
         "Save Changes"
       end].join.html_safe
    end
  end

  def ov_modal **options, &block
    id = "ov-modal"
    tag.div class: "modal fade ov-modal",
            id: "ov-modal",
            tabindex: -1,
            data: {action:"show.bs.modal->fill"},
            aria: {labelledby: "#{id}Label", hidden: "true"} do
      tag.div class: "modal-dialog ov-modal-dialog" do
        tag.div class: "modal-content ov-modal-content" do
          [ ov_modal_header(**options, id: id),
            ov_modal_body(**options, id: id, &block),
            ov_modal_footer(**options, id: id)
          ].join.html_safe
        end
      end
    end
  end
end
