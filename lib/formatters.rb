formatter(:linked) do |subject, column|
  link_to(subject.send(column), subject)
end

formatter(:linked_to) do |subject, column|
  object = subject.send(column)
  object ? link_to(object, object) : ''
end

formatter(:tail_link, :no_header => true) do |subject, text, *args|
  html_options = args.extract_options!.clone
  url = args + [subject]

  if html_options.delete(:ajax)
    options = {:method => html_options.delete(:method), :confirm => html_options.delete(:confirm), :url => url}
    link_to_remote text, options, html_options
  else
    link_to text, url, html_options
  end
end

formatter(:edit_link) do |subject, text, options|
  options ||= {}
  options[:method] = 'get' if options[:ajax]
  tail_link(text, :edit, options).execute(subject)
end

formatter(:destroy_link) do |subject, text, options|
  options ||= {}
  options.reverse_merge!(:confirm => 'Are you sure?', :method => 'delete')
  tail_link(text, options).execute(subject)
end

formatter(:with_percent) do |subject, column, total_column|
  number, total = subject.send(column).to_i, subject.send(total_column).to_i
  percent = total == 0 ? 0 : number.to_f / total * 100
  "#{number} (#{helper.number_to_percentage(percent)})"
end

formatter(:random) do |subject, column, range|
  rand(range.last - range.first) + range.first
end
