require 'active_support'
require 'action_view'
require 'action_controller'
%w{html_attributes table/cell table/row total formatter tables_helper table}.each {|f| require File.dirname(__FILE__) + "/tableasy/#{f}" }

module Tableasy
  module FormattersHelper
  end

  class FormattersContext
    @@formatters = {}

    def self.formatter(name, options = {}, &block)
      options.reverse_merge!(:initial => true, :header => :default)
      options[:initial] = false if options[:header_only]

      formatter = Formatter.new(options, &block)
      FormattersHelper.module_eval do
        define_method(name) do |column, *args|
          Formatter::Column.new(self, formatter, column, *args.push(options))
        end
      end
      @@formatters[name] = formatter
    end

    def self.[](key)
      @@formatters[key.to_sym] or raise "Formatter not found '#{key}'"
    end

    def self.[]=(key, value)
      @@formatters[key.to_sym] = value
    end
  end

  def self.reload_formatters(file)
    FormattersContext.module_eval(File.read(file), file)
  end
end

class ActionView::Base
  include Tableasy::TablesHelper
  include Tableasy::FormattersHelper
end
