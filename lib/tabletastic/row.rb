module TableTastic
  class Row
    include HtmlAttributes
    attr_reader :record, :columns

    def initialize(record, columns, total_row = false)
      @record = record

      @columns = columns.collect do |value|
        Column.new(record, value)
      end
      @total_row = total_row
      @html = {}
    end

    def total_row?
      @total_row
    end
  end
end
