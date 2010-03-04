require File.dirname(__FILE__) + "/../spec_helper"

describe Tableasy::Table do
  describe 'with created table' do
    before :each do
      build :andrius
      @table = Tableasy::Table.new
      @cell = Tableasy::Table::Cell.new(nil, 'val')
    end

    it "should allow to add row" do
      @table.add_row([@cell, @cell])
      @table.rows[0].cells.should == [@cell, @cell]
    end

    it "should allow to add row with html" do
      @table.add_row([@cell], :class => 'total')
      @table.rows[0].html.should == {:class => 'total'}
    end
  end
end
