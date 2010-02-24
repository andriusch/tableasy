module Tableasy
  module TablesHelper
    def table_for(klass, list, *columns)
      options = columns.extract_options!

      content_tag('table', options[:html]) do
        content = ''
        content << content_tag('tr') do
          columns.select {|column| column.to_sym }.collect do |column|
            content_tag 'th', klass.human_attribute_name(column.to_sym)
          end.join
        end

        content << list.each_with_index.collect do |item, index|
          row = Row.new(item, columns)
          row.html[:class] = index.odd? ? 'even' : 'odd'
          yield row if block_given?
          content_row(item, row)
        end.join

        if options[:total]
          item = Total.new(list)
          caption = I18n.t('tableasy.total', :raise => true) rescue 'Total: '
          row = Row.new(item, columns[1..-1].unshift(caption), true)
          row.html[:class] = 'total-row'
          yield row if block_given?
          content << content_row(item, row, :first_header => true)
        end

        content
      end
    end

    def content_row(object, row, options = {})
      content_tag_for('tr', object, :row, row.html) do
        ''.tap do |result|
          if options[:first_header]
            column = row.columns.shift
            result << content_tag('th', column.value, column.html)
          end
          result << row.columns.collect { |column| content_tag('td', column.value, column.html) }.join
        end
      end
    end

  end
end
