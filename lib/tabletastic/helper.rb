module TableTastic
  module Helper
    module ClassMethods
      def formatter(name, options = {}, &block)
        
      end
    end

    def self.included(object)
      object.extend(ClassMethods)
    end
  end
end
