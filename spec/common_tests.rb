module CommonTests
  def pp x
    node = Nokogiri::HTML(x)
    puts node.to_xhtml(indent: 2)
  end

  def views_models_edit **options
    render
    pp response if options[:pp]
    name = object.class_name_u
    attrs = object.get_form options[:form] || "form"
    assert_select "form[action=?][method=?]",
                  polymorphic_path(object), "post" do
      attrs.keys.each do |k|
        # ignoring associaitons
        next unless object.attribute_names.member?(k)
        assert_select "label[for=?]", k.to_s
        #TODO: assert_select "name[for=?]", "#{name}[#{k}]"
        #TODO: assert_select "input[name=?]", "story_task[title]"
      end
    end
  end

  def requests_get path, **options
    get path
    if options[:pp]
      puts "Status: #{response.status}"
      pp response.body
    end
    expect(response).to be_successful
  end

  def requests_create klass, attributes, num
    expect {
      post polymorphic_url(klass),
           params: { object.class_name_u => attributes }
    }.to change(klass, :count).by(num)
  end

  def self.included(base)
    base.extend ClassMethods
  end

  def process_attributes attrx, &block
    if attrx.is_a? Array
      attrx.each do |attrs|
        yield attrs
      end
    else
      yield attrx
    end
  end

  def one attrx
    if attrx.is_a? Array
      attrx.first
    else
      attrx
    end
  end

  module ClassMethods

    def views_models_edit **options
      it "renders form with attributes" do
        views_models_edit **options
      end
    end

    def views_models_index **options
      it "renders list of model objects" do
        render
        pp response if options[:pp]
        name = objects.first.class_name_u

        assert_select "table" do
          assert_select "tr", 1 + objects.size
        end
      end
    end

    def views_models_show **options
      it "renders attributes" do
        render
        pp response if options[:pp]
        name = object.class_name_u
        attrs = object.get_template
        assert_select "div[class=?]", "ov-display" do
          attrs.keys.each do |k|
            next unless object.attribute_names.member?(k)
            assert_select "label[for=?]", k.to_s
          end
        end
      end
    end

    def views_models_new **options
      it "renders new form" do
        render
        pp response if options[:pp]
        name = object.class_name_u
        attrs = object.get_form
        assert_select "form[action=?][method=?]",
                      polymorphic_path(object), "post" do
          attrs.keys.each do |k|
            next unless object.attribute_names.member?(k)
            assert_select "label[for=?]", k.to_s
          end
        end
      end
    end

    def requests_get_index **options
      it "GET /index renders a successful response" do
        requests_get polymorphic_url(object.class)
      end
    end

    def requests_get_new **options
      it "GET /new renders a successful response" do
        requests_get new_polymorphic_url(object.class), **options
      end
    end

    def requests_get_show **options
      it "GET /show renders a successful response" do
        requests_get new_polymorphic_url(object), **options
      end
    end

    def requests_get_edit **options
      it "GET /show renders a successful response" do
        requests_get edit_polymorphic_url(object), **options
      end
    end

    def ctx(label, &block)
      @zzz ||= []
      @zzz << label
      yield
    ensure
      @zzz.pop
    end

    def ctx_path
      @zzz ||= []
      @zzz.join " "
    end

    def itx label, &block
      it "#{ctx_path} #{label}", &block
    end

    def requests_post_create **options
      ctx "POST /create" do
        ctx "with valid parameters" do
          itx "creates a new #{object_class}" do
            process_attributes valid_attributes do |attributes|
              requests_create object.class, attributes, 1
            end
          end
          itx "redirects to the created #{object_entity}" do
            process_attributes valid_attributes do |attributes|
              post polymorphic_url(object.class),
                   params: { object.class_name_u => attributes }
              expect(response).to redirect_to(polymorphic_url(object.class.last))
            end
          end
        end
        ctx "with invalid parameters" do
          itx "does not create a new #{object_class}" do
            process_attributes invalid_attributes do |attributes|
              requests_create object.class, attributes, 0
            end
          end
          itx "renders a response with 422 status (i.e. to display the 'new' template)" do
            process_attributes invalid_attributes do |attributes|
              post polymorphic_url(object.class),
                   params: { object.class_name_u => attributes }
              expect(response).to have_http_status(:unprocessable_entity)
            end
          end
        end
      end
    end

    def requests_patch_update
      ctx "PATCH /update" do
        ctx "with valid parameters" do
          itx "updates the requested #{object_entity}" do
            obj = object.class.create! one(valid_attributes)
            patch polymorphic_url(obj),
                  params: {object.class_name_u => new_attributes}
            expect(response).to redirect_to(polymorphic_url(obj))
            obj.reload
            new_attributes.each do |attr, value|
              # TODO: rather than skipping, should walk through nested
              # parameters
              next if /_attributes$/ =~ attr.to_s
              expect(obj.send(attr)).to eq value
            end
          end
          itx "redirects to #{object_entity}" do
            obj = object.class.create! one(valid_attributes)
            patch polymorphic_url(obj),
                  params: {object.class_name_u => new_attributes}
            obj.reload
            expect(response).to redirect_to(polymorphic_url(obj))
          end
        end
        ctx "with invalid parameters" do
          itx "renders a response with 422 status (i.e. to display the 'edit' template)" do
            obj = object.class.create! one(valid_attributes)
            patch polymorphic_url(obj),
                  params: {object.class_name_u => invalid_attributes}
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end
    end

    def requests_delete_destroy
      ctx "DELETE /destroy" do
        itx "destroys the requests #{object_entity}" do
          obj = object.class.create! one(valid_attributes)
          expect {
            delete polymorphic_url(obj)
          }.to change(object.class, :count).by(-1)
        ensure
          obj.destroy
        end

        itx "redirects to the people list" do
          obj = object.class.create! one(valid_attributes)
          delete polymorphic_url(obj)
          expect(response).to redirect_to(polymorphic_url(object.class))
        ensure
          obj.destroy
        end
      end
    end
  end
end
