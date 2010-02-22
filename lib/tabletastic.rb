require 'active_support'
require 'action_view'
require 'tabletastic/formatter'
require 'tabletastic/helper'

module TableTastic
  module Formatters
  end

  class FormattersContext
    def self.formatter(name, options = {}, &block)
      Formatter.new(&block).tap do |formatter|
        formatter.format_header { nil } if options[:no_header]

        Formatters.module_eval do
          define_method(name) do |column, *args|
            ColumnFormatter.new(self, formatter, column, *args)
          end
        end
      end
    end
  end

  def self.reload_formatters(file)
    FormattersContext.module_eval(File.read(file))
  end
end

module ActionView::Helpers
  include TableTastic::Formatters
end
