$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'tableasy'
require 'rspec'
require 'blueprints'
require 'mocha'
require 'fake_models'
require 'action_view/template/handlers/erb'

RSpec.configure do |config|
  config.mock_with :mocha
  config.before { Tableasy.reload_formatters(File.dirname(__FILE__) + '/../lib/formatters.rb')}

  Blueprints::Context.send(:include, Mocha::API)
end

Blueprints.enable do |config|
  config.root = File.dirname(__FILE__) + '/..'
end

class HelperObject
  include ActionView::Helpers
  include Tableasy::TablesHelper
  include Tableasy::FormattersHelper
  attr_accessor :output_buffer
#  include TableHelper

  def url_for(args)
    args = [args] unless args.is_a?(Array)
    args.collect do |object|
      if object.is_a? Symbol or object.is_a? String
        "/#{object}"
      else
        "/#{object.class.to_s.tableize}/#{object}"
      end
    end.join
  end

  def protect_against_forgery?
    false
  end
end

def helper
  @helper ||= HelperObject.new
end
