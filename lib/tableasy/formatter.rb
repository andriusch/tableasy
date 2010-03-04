module Tableasy
  class Formatter
    class Column
      attr_reader :column

      def initialize(context, formatter, column, *args)
        options = args.extract_options!
        @context = context
        @formatter = formatter
        @args = args
        if options[:no_initial]
          @args.unshift(column)
        else
          @column = column
        end
      end

      def execute(record)
        @context.instance_exec(record, *@args, &@formatter.block)
      end

      def to_sym
        @formatter.format_header(@column || @args.first)
      end
    end

    attr_reader :block

    def initialize(&block)
      @block = block
      @format_header = Proc.new {|header| header }
    end

    def format_header(header = nil, &block)
      if block
        @format_header = block
      else
        @format_header.call(header)
      end
    end
  end
end
