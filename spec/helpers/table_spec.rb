require File.dirname(__FILE__) + "/../spec_helper"

describe Tableasy::Table do
  before :each do
    @table = Tableasy::Table.new(Person, ["obj1"], [:b, :a], {:format => :vertical, :headers => 'headers'})
  end

  it "should return true if table is vertical" do
    @table.vertical?.should be_true
    @table.horizontal?.should be_false
  end

  it 'should return attributes as row and obects as columns if table vertical' do
    @table.rows.should == [:b, :a]
    @table.columns.should == ["obj1"]
  end

  it 'should return attributes as columns and obects as rows if table vertical' do
    table = Tableasy::Table.new(Person, ["obj1"], [:b, :a], {})
    table.columns.should == [:b, :a]
    table.rows.should == ["obj1"]
  end

  it "should return item as new instance if table is vertical" do
    pers = mock("person")
    Person.expects(:new).returns(pers)
    @table.item("some_item").should == pers
  end

  it "should return given item if table is horizontal" do
    @table.expects(:vertical?)
    Person.expects(:new).never
    @table.item(:sym).should == :sym
  end

end