module Tableasy
  class Column
    include HtmlAttributes
    attr_reader :value

    def initialize(record, value)
      @record = record
      self.value = value
    end

    def value=(value)
      value = value.execute(@record) if value.is_a?(Tableasy::ColumnFormatter)
      value = @record.send(value) if value.is_a?(Symbol)
      @value = value
    end
  end
end
