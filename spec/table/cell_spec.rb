require File.dirname(__FILE__) + "/../spec_helper"

describe Tableasy::Table::Cell do
  before do
    build :andrius
  end

  describe 'with cell created' do
    before do
      @cell = Tableasy::Table::Cell.new(@andrius, 'andrius')
    end

    it "should be created" do
      @cell.subject.should == @andrius
      @cell.value = 'andrius'
      @cell.header.should be_false
      @cell.tag.should == 'td'
    end

    it "should allow to assign html attributes" do
      @cell.html[:class] = 'class'
      @cell.html.should == {:class => 'class'}
    end
  end

  it "should allow to create header cell" do
    cell = Tableasy::Table::Cell.new(@andrius, 'andrius', true)
    cell.header.should be_true
    cell.tag.should == 'th'
  end

  it "should take value from object if symbol is passed as value" do
    cell = Tableasy::Table::Cell.new(@andrius, :name)
    cell.value.should == 'Andrius'
  end

  it "should execute formatter if it's passed as value" do
    f = Tableasy::Formatter.new {|cell, string| cell.value += string }
    cf = Tableasy::Formatter::Column.new(self, f, :to_s, ' hello')
    cell = Tableasy::Table::Cell.new(@andrius, cf)
    cell.value.should == 'Andrius hello'
  end
end
