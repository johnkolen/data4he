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
    path = "#{head}#{tail}"
    node = Nokogiri.HTML(elem)
    assert_dom node, "div[class=\"ov-display\"]", d
    assert_dom node, "form[class=\"ov-form\"]", 1 - d do
      assert_dom node, "label[for=?]", rest.last
      assert_dom node, "input[name=?]", path, 1 - d
      assert_dom node, "div[class=\"ov-text\"]", d
    end
  end

end
