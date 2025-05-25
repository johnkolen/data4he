module ObjectViewModal
  def ov_modal_header **options
    id = options[:id] || "modal"
    tag.div class: "modal-header ov-modal-header" do
      [ tag.div(options[:title] || "Title",
               class: "modal-title ov-modal-title", # add fs-5 to css
               id: "#{id}Label"),
       tag.button(type: "button",
                  class: "btn-close",
                  data: { "bs-dismiss": "modal" },
                  aria: { label: "Close" })
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
      [ tag.button("Close",
                  type: "button",
                  class: "btn btn-secondary",
                  data: { "bs-dismiss": "modal" },
                  aria: { label: "Close" })
      ].concat(options[:footer_buttons] || []).join.html_safe
    end
  end

  def ov_modal **options, &block
    id = "ov-modal"
    tag.div class: "modal fade ov-modal",
            id: "ov-modal",
            tabindex: -1,
            # data: {action:"show.bs.modal->fill hide.bs.modal->close"},
            aria: { labelledby: "#{id}Label", hidden: "true" } do
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

  def ov_modal_objects klass, **options, &block
    obj = klass.first
    id = "#{obj.class.to_s.underscore}_frame"
    tag.div data: { controller: "modal-object" } do
      [ capture(&block),
        ov_modal_object_modal(id, obj)
      ].join.html_safe
    end
  end

  def ov_modal_object_modal id, obj, **options, &block
    buttons = [
      tag.button("Edit",
                 type: "button",
                 data: { action: "click->modal-object#edit" },
                 class: "btn btn-primary"),
      tag.button("Show",
                 type: "button",
                 data: { action: "click->modal-object#view" },
                 class: "btn btn-primary")
    ]
    ov_modal footer_buttons: buttons do
      turbo_frame_tag id,
                      src: nil,
                      # loading: :lazy,
                      data: {
                        "modal-object-target": :frame,
                        edit: edit_polymorphic_path(obj, params: { tf: 1 }),
                        view: polymorphic_path(obj, params: { tf: 1 })
                      }
    end
  end

  def ov_modal_objects_view klass, content, turbo, **options, &block
    if @turbo
      id = "#{klass.to_s.underscore}_frame"
      turbo_frame_tag id do
        content
      end
    else
      capture(&block)
    end
  end
end
