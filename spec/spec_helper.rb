$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'tableasy'
require 'spec'
require 'spec/autorun'
require 'blueprints'
require 'mocha'
require 'fake_models'

Spec::Runner.configure do |config|
  config.enable_blueprints :orm => :none, :root => File.dirname(__FILE__) + '/..'
  config.mock_with :mocha
  config.before { Tableasy.reload_formatters(File.dirname(__FILE__) + '/../lib/formatters.rb')}

  Blueprints::Context.send(:include, Mocha::API)
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
