module TableTastic
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
end
