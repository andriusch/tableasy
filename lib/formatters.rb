formatter(:default_header, :header_only => true) do |cell, column|
  cell.value = cell.subject.human_attribute_name(column)
end

formatter(:linked) do |cell|
  cell.value = link_to(cell.value, cell.subject)
end

formatter(:linked_to) do |cell|
  cell.value = cell.value ? link_to(cell.value, cell.value) : ''
end

formatter(:tail_link, :header => nil, :initial => false) do |cell, text, *args|
  html_options = args.extract_options!.clone
  url = args + [cell.subject]
  cell.value = link_to text, url, html_options
end

formatter(:edit_link, :initial => false, :header => nil) do |cell, text, options|
  options ||= {}
  tail_link(text, :edit, options).execute(cell)
end

formatter :my_edit_link, :initial => false, :header => nil do |cell|
  tail_link('my edit', :edit).execute(cell)
end

formatter(:destroy_link, :initial => false, :header => nil) do |cell, text, options|
  options ||= {}
  options.reverse_merge!(:confirm => 'Are you sure?', :method => 'delete')
  tail_link(text, options).execute(cell)
end

formatter(:joined_array) do |cell|
  cell.value = cell.value.collect { |val| h(val) }.join(tag('br')).html_safe
end

formatter(:with_percent) do |cell, total_column|
  number, total = cell.value.to_i, cell.subject.send(total_column).to_i
  percent = total == 0 ? 0 : number.to_f / total * 100
  cell.value = "#{number} (#{number_to_percentage(percent)})"
end

formatter(:random, :initial => false) do |cell, header, range|
  cell.value = rand(range.last - range.first) + range.first
end

formatter(:header_column, :header => nil, :initial => false) do |cell, text|
  cell.value = text
  cell.html[:colspan] = 2
  cell.header = true
end
