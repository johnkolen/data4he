module HelperDefs
  def pp x
    node = Nokogiri::HTML(x)
    puts node.to_xhtml(indent: 2)
  end

  def with_access &block
    self.class.access_class.user = Access.user
    helper.ov_with_access_class self.class.access_class, &block
  end

  def h_ov_check *args, **options, &block
    _h_ov_check yield, *args, **options
  end

  DELTA = {form: 0, display: 1}
  def _h_ov_check elem, kind, obj, *rest, **options
    pp(elem) if options[:pp]
    head = obj.class.to_s.underscore
    attr = rest.last
    d = DELTA[kind]
    tail = rest.map{|x| "[#{x}]" }.join
    x = rest.pop
    mid = rest.map{|x| "[#{x}]" }.join
    rest.push x
    path = "#{head}#{tail}"
    node = Nokogiri.HTML(elem)
    @attributes ||= [rest.last]
    no_input = options[:no_input] || []
    no_label = options[:no_label] || []
    no_display = options[:no_display] || []
    display = options[:display] || []
    puts no_input.inspect
    if kind == :form
      assert_dom node, "div[class*=?]", "ov-display", 0
      assert_dom node, "form[class*=?]", "ov-form", 1 do
        @attributes.each do |attr|
          assert_dom node, "label[for=?]", attr,
                     no_label.member?(attr) ? 0 : 1
          assert_dom node, "input[name=?]", "#{head}#{mid}[#{attr}]",
                     no_input.member?(attr) ? 0 : 1
        end
        assert_dom node, "div[class*=?]", "display-#{attr}",
                   display.member?(attr) ? 1 : 0
      end
    else
      assert_dom node, "form[class*=?]", "ov-form", 0
      assert_dom node, "div[class*=?]", "ov-display", {minimum: 1} do
        @attributes.each do |attr|
          assert_dom node, "label[for=?]", attr,
                     no_label.member?(attr) ? 0 : 1
          assert_dom node, "input[name=?]", "#{head}#{mid}[#{attr}]", 0
          assert_dom node, "div[class*=?]", "display-#{attr}",
                     no_display.member?(attr) ? 0 : 1
        end
      end
    end
  ensure
    @attributes = nil
  end

end
