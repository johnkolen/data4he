module ObjectViewBase
  # for testing
  def set_ov_obj(obj)
    @ov_obj = obj
  end
  def get_ov_obj
    @ov_obj
  end

  def set_ov_form(form)
    @ov_form = form
  end

  def object_view(obj)
    @ov_obj = obj
  end

  def ov_access_class
    @ov_access_class || Access
  end

  def set_ov_access_class klass
    @ov_access_class = klass
  end

  def ov_with_access_class klass, &block
    hold = @ov_access_class
    @ov_access_class = klass
    yield
    @ov_access_class = hold
  end

  ###################################

  def ov_allow? resource, label, &block
    ov_access_class.allow? resource, label, &block
  end

  ###################################

  def ov_form(obj = nil, **options, &block)
    rv = nil
    ov_allow? obj, :edit do
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
      rv = tag.div f, class: "ov-form-wrapper"
    end
    rv
  end

  ###################################

  def ov_display(obj = nil, &block)
    rv = nil
    ov_allow? obj, :view do
      @ov_access = :view
      return capture &block if @ov_form
      @ov_obj = obj || @ov_obj
      content = capture &block
      rv = tag.div content, id: dom_id(@ov_obj), class: "ov-display"
    end
    rv
  end


  ###################################

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
