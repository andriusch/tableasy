formatter(:linked) do |subject, column|
  link_to(subject.send(column), subject)
end

formatter(:linked_to) do |subject, column|
  object = subject.send(column)
  link_to object, object
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

#def edit_link(*url)
#  options = url.extract_options!
#  options.merge!(:method => 'get') if options[:ajax]
#  url.unshift(:edit).push(options)
#  tail_link "Edit", *url
#end
#
#def destroy_link(*url)
#  options = url.extract_options!
#  options.reverse_merge!(:confirm => 'Are you sure?', :method => 'delete')
#  url.push(options)
#  tail_link "Delete", *url
#end

formatter(:with_percent) do |subject, column, total_column|
  number, total = subject.send(column).to_i, subject.send(total_column).to_i
  percent = total == 0 ? 0 : number.to_f / total * 100
  "#{number} (#{helper.number_to_percentage(percent)})"
end

formatter(:random) do |subject, column, range|
  rand(range.last - range.first) + range.first
end
