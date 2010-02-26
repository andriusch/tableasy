module Tableasy
  class Table
    attr_reader :rows, :columns, :type, :klass, :headers
    
    def initialize(klass, rows, columns, options)
      @klass = klass
      @type = (options[:format] == :vertical) ? :vertical : :horizontal
      @headers = options[:headers] || klass.to_s
      @rows, @columns = vertical? ?  [columns, rows] : [rows, columns]
    end

    def vertical?
      @type == :vertical
    end

    def horizontal?
      !vertical?
    end

    def item(object)
      horizontal? ? object : @klass.new
    end
  end
end
