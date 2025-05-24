module ObjectViewTable
  def ov_table(klass, objs = [])
    return unless objs
    sym = klass.to_s.underscore.to_sym
    obj = klass.new
    obj.add_builds!

    content = [
      render(partial: "table_row",
             locals: { sym => [ obj ] })
    ]
    objs.each do |obj|
      content << render(partial: "table_row", locals: { sym => obj })
    end
    tag.table content.join.html_safe,
              id: "#{klass.to_s.underscore}_table",
              class: "ov-display"
  end

  def ov_table_row(obj = nil, &block)
    @ov_obj = obj || @ov_obj
    @ov_table_row = true
    content = capture &block
    @ov_table_row = false
    if @ov_obj.is_a? Array
      tag.tr content.html_safe,  class: "ov-table-row-head"
    else
      content += '<td class="ov-table-col">'.html_safe
      content += ov_show
      content += ov_edit
      content += ov_delete
      content += "</td>".html_safe
      tag.tr content.html_safe, id: dom_id(@ov_obj), class: "ov-table-row"
    end
  end

  def ov_col(oattr)
    if @ov_obj.is_a? Array
      tag.td(@ov_obj.first.send("#{oattr}_label"), class: "ov-table-hdr")
    else
      tag.td(@ov_obj.send("#{oattr}_str"), class: "ov-table-col")
    end
  end
end
