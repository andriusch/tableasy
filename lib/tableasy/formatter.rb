module Tableasy
  class Formatter
    class Column
      attr_reader :column

      def initialize(context, formatter, column, *args)
        options = args.extract_options!
        @context = context
        @formatter = formatter
        @args = args
        if options[:initial]
          @column = column
          @header_args = [@column] + @args
        else
          @args.unshift(column)
          @header_args = @args
        end
        @header_args.collect! { |arg| arg.is_a?(Tableasy::Formatter::Column) ? arg.column : arg  }
      end

      def execute(cell)
        @context.instance_exec(cell, *@args, &@formatter.block)
      end

      def header
        @header ||= @formatter.header.is_a?(Tableasy::Formatter) ? self.class.new(@context, @formatter.header, *@header_args) : @formatter.header
      end

      def header_only?
        @formatter.header_only?
      end
    end

    attr_reader :block, :header

    def initialize(options, &block)
      @block = block
      @header_only = options[:header_only]
      if header_only?
        @header = self
      else
        @header = options[:header]
        @header = FormattersContext[:"#{@header}_header"] if @header.is_a?(Symbol)
      end
    end

    def header_only?
      @header_only
    end
  end
end
