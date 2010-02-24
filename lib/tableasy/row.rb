module Tableasy
  class Row
    include HtmlAttributes
    attr_reader :record, :columns, :vertical

    def initialize(record, columns, total_row = false, vertical = false)
      @record = record
      @vertical = vertical

      @columns = columns.collect do |value|
        vertical ? Column.new(value, record) : Column.new(record, value)
      end
      @columns.unshift(Column.new("headers", record.to_s)) if vertical
      @total_row = total_row
      @html = {}
    end

    def total_row?
      @total_row
    end
  end
end
