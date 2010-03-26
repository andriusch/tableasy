module Tableasy
  module TablesHelper
    def table_for(klass, list, *columns)
      options = columns.extract_options!

      table = Table.new
      # Add header row
      row = columns.collect {|column| header_cell(column, klass) }
      table.add_row(row, :header => true)

      list.each_with_index do |object, index|
        table.add_row(table_row(object, columns), :id => dom_id(object, :row), :class => "#{dom_class(object)} #{index.even? ? "odd" : "even"}")
      end

      if options[:total]
        item = Total.new(list)
        caption = I18n.t('tableasy.total', :raise => true) rescue 'Total: '
        table.add_row(table_row(item, columns[1..-1]).unshift(Table::Cell.new(item, caption, true)), :class => 'total-row', :total => true)
      end

      content_tag('table', options[:html]) do
        table.rows[1..-1].each {|row| yield row } if block_given?
        table.rows.collect {|row| content_row(row) }.join
      end
    end

    def data_list(object, *columns)
      options = columns.extract_options!
      table = Table.new

      columns.each do |column|
        table.add_row([header_cell(column, object.class), Table::Cell.new(object, column)].compact)
      end

      content_tag('table', options[:html]) do
        table.rows.collect {|row| content_row(row) }.join
      end
    end

    def content_row(row)
      content_tag('tr', row.html) do
        row.cells.collect {|cell| content_tag(cell.tag, cell.value, cell.html) }.join
      end
    end

    protected

    def header_cell(column, klass)
      column = default_header(column) if column.is_a?(Symbol)
      Table::Cell.new(klass, column, true)
    end

    def table_row(object, columns)
      columns.collect do |column|
        Table::Cell.new(object, column)
      end
    end
  end
end
