formatter(:linked) do |cell|
  cell.value = link_to(cell.value, cell.subject)
end

formatter(:linked_to) do |cell|
  cell.value = cell.value ? link_to(cell.value, cell.value) : ''
end

formatter(:tail_link, :no_header => true, :no_initial => true) do |cell, text, *args|
  html_options = args.extract_options!.clone
  url = args + [cell.subject]

  cell.value = if html_options.delete(:ajax)
    options = {:method => html_options.delete(:method), :confirm => html_options.delete(:confirm), :url => url}
    link_to_remote text, options, html_options
  else
    link_to text, url, html_options
  end
end

formatter(:edit_link, :no_initial => true, :no_header => true) do |cell, text, options|
  options ||= {}
  options[:method] = 'get' if options[:ajax]
  tail_link(text, :edit, options).execute(cell)
end

formatter(:destroy_link, :no_initial => true, :no_header => true) do |cell, text, options|
  options ||= {}
  options.reverse_merge!(:confirm => 'Are you sure?', :method => 'delete')
  tail_link(text, options).execute(cell)
end

formatter(:joined_array) do |cell|
  cell.value = cell.value.join("<br />")
end

formatter(:with_percent) do |cell, total_column|
  number, total = cell.value.to_i, cell.subject.send(total_column).to_i
  percent = total == 0 ? 0 : number.to_f / total * 100
  cell.value = "#{number} (#{number_to_percentage(percent)})"
end

formatter(:random, :no_initial => true) do |cell, header, range|
  cell.value = rand(range.last - range.first) + range.first
end

formatter(:header_row, :no_header => true, :no_initial => true) do |cell, text|
  cell.value = text
  cell.html[:colspan] = 2
  cell.header = true
end
