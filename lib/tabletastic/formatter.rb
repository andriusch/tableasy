module TableTastic
  class ColumnFormatter
    def initialize(context, formatter, *args)
      @context = context
      @formatter = formatter
      @args = args
    end

    def execute(record)
      @context.instance_exec(record, *@args, &@formatter.block)
    end

    def header
      @formatter.format_header(@args.first)
    end
  end

  class Formatter
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
