module Tableasy
  class Table
    class Row
      include HtmlAttributes
      attr_reader :cells

      def initialize(cells, html = {})
        @cells = cells
        @total, @header = html.delete(:total), html.delete(:header)
        @html = html
      end

      def total_row?
        @total
      end

      def header_row?
        @header
      end
    end
  end
end
