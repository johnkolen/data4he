class ObjViewViewsGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  def copy_files
    [
      "edit.html.erb",
      "index.html.erb",
      "new.html.erb",
      "show.html.erb"
    ].each do |x|
      copy_file x, "app/views/#{name.pluralize}/#{x}"
    end
  end
  def copy_template_files
    [
      "_form.html.erb",
      "_table_row.html.erb",
      "_object.html.erb"
    ].each do |x|
      template "#{x}.tt",
               "app/views/#{name.pluralize}/#{x}".sub("object", name)
    end
  end
  # def copy_index_file
  #   copy_file "index.html.erb", "app/views/#{name}/index.html.erb"
  # end
  # def copy_new_file
  #   copy_file "new.html.erb", "app/views/#{name}/new.html.erb"
  # end
  # def copy_edit_file
  #   copy_file "edit.html.erb", "app/views/#{name}/edit.html.erb"
  # end
end
