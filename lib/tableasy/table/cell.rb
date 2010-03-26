module Tableasy
  class Table
    class Cell
      include HtmlAttributes
      attr_accessor :value, :header
      attr_reader :subject

      def initialize(subject, value, header = false)
        @subject = subject
        @header = header
        self.value = value
      end

      def value=(value)
        value = value.header if @header and value.is_a?(Tableasy::Formatter::Column) and !value.header_only?
        if value.is_a?(Tableasy::Formatter::Column)
          self.value = value.column if value.column
          value.execute(self)
        else
          value = @subject.send(value) if value.is_a?(Symbol)
          @value = value
        end
      end

      def tag
        @header ? 'th' : 'td'
      end
    end
  end
end
