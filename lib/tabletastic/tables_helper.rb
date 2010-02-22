module TablesHelper
  include FormattingHelper
  include TableTastic::Helper

  formatter :field_of_object do |subject, helper, column|
    subject.send(column)
  end

  def table_for(klass, list, *columns, &block)
    options = columns.extract_options!

    concat(content_tag('table') do
        content = ''
        content << content_tag('tr') do
          columns.select {|column| column.to_sym }.collect do |column|
            content_tag 'th', klass.human_attribute_name(column.to_sym)
          end
        end

        content << list.collect do |item|
          row = Row.new(item, columns)
          yield row if block_given?
          content_row(item, row)
        end.join

        content << @content_for_table_bottom.to_s
        @content_for_table_bottom = ''
        content
      end)
  end

  def table_with_totals_for(klass, list, *columns, &block)
    options = columns.extract_options!
    content_for :table_bottom do
      item = Total.new(list)
      row = Row.new(item, columns[1..-1].unshift(t('common.total')), true)
      row.html[:class] = 'total-row'
      yield row if block_given?
      content_row(item, row, :first_header => true)
    end

    table_for(klass, list, *columns.push(options), &block)
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

  module HtmlAttributes
    def html
      @html ||= {}
    end

    def method_missing(method, *args)
      if method.to_s =~ /(.*)=/
        attr = $1.to_sym
        html[attr] = args.shift
      end
    end
  end

  class Row
    include HtmlAttributes
    attr_reader :record, :columns

    def initialize(record, columns, total_row = false)
      @record = record

      @columns = columns.collect do |value|
        value = TableTastic::FieldOfObjectFormatter.new(record, value) if value.is_a?(Symbol)
        Column.new(record, value)
      end
      @total_row = total_row
      @html = {}
    end

    def total_row?
      @total_row
    end
  end

  class Column
    include HtmlAttributes
    attr_reader :value

    def initialize(record, value)
      @record = record
      self.value = value
    end

    def value=(value)
      value = value.to_s(@record) if value.is_a?(TableTastic::Formatter)
      @value = value
    end
  end

  class Total
    undef_method :id

    def initialize(list)
      @list = list
    end

    def method_missing(column)
      @list.collect {|item| item.send(column) }.inject {|total, item| total + item }
    end
  end
end
