module Tableasy
  class Total
    undef_method :id if method_defined?(:id)

    def initialize(list)
      @list = list
    end

    def method_missing(column)
      @list.collect {|item| item.send(column) }.inject {|total, item| total + item }
    end
  end
end
