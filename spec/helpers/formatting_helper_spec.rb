require File.dirname(__FILE__) + "/../spec_helper"

describe 'Formatters' do
  before do
    build :andrius
  end

  it "should show linked object" do
    formatter = helper.linked(:name)
    Tableasy::Table::Cell.new(@andrius, formatter).value.should == '<a href="/people/Andrius">Andrius</a>'
  end

  it "should show object linked to itself" do
    build :project
    formatter = helper.linked_to(:leader)
    Tableasy::Table::Cell.new(@project, formatter).value.should == '<a href="/people/Andrius">Andrius</a>'
  end

  it "should show nothing when linked object doesn't exist" do
    build :project
    @project.leader = nil
    formatter       = helper.linked_to(:leader)
    Tableasy::Table::Cell.new(@project, formatter).value.should == ''
  end

  it "should show number with percent" do
    @andrius.stubs(:work_hours).returns(100, 100, 13, nil)
    @andrius.stubs(:remaining).returns(8, -8, 8, nil)

    formatter = helper.with_percent(:remaining, :work_hours)
    ["8 (8.000%)", "-8 (-8.000%)", "8 (61.538%)", "0 (0.000%)"].each do |result|
      Tableasy::Table::Cell.new(@andrius, formatter).value.should == result
    end
  end

  it "should return random number in range" do
    helper.expects(:rand).with(30).returns(23)
    formatter = helper.random(:hours, 100..130)
    Tableasy::Table::Cell.new(nil, formatter).value.should == 123
  end

  describe "joined array" do
    it "should allow joining array" do
      @andrius  = mock(:ages => (20..23).to_a)
      formatter = helper.joined_array(:ages)
      Tableasy::Table::Cell.new(@andrius, formatter).value.should == "20<br />21<br />22<br />23"
    end

    it "should escape attribute values" do
      @andrius  = mock(:ages => ['<br>'])
      formatter = helper.joined_array(:ages)
      Tableasy::Table::Cell.new(@andrius, formatter).value.should == "&lt;br&gt;"
    end
  end

  describe 'tail_link' do
    before do
      build :andrius
    end

    it "should allow show link with no symbol" do
      formatter = helper.tail_link('hello')
      Tableasy::Table::Cell.new(@andrius, formatter).value.should == '<a href="/people/Andrius">hello</a>'
      formatter.header.should == nil
    end

    it "should allow passing custom url" do
      formatter = helper.tail_link('hello', :edit)
      Tableasy::Table::Cell.new(@andrius, formatter).value.should == '<a href="/edit/people/Andrius">hello</a>'
    end

    it "should allow passing custom url and html attributes" do
      formatter = helper.tail_link('hello', :edit, :method => :delete)
      Tableasy::Table::Cell.new(@andrius, formatter).value.should == helper.link_to('hello', [:edit, @andrius], :method => :delete)
    end

    it "should allow creating edit url" do
      formatter = helper.edit_link('(edit)')
      Tableasy::Table::Cell.new(@andrius, formatter).value.should == helper.link_to('(edit)', [:edit, @andrius])
    end

    it "should allow creating delete link" do
      formatter = helper.destroy_link('(delete)')
      Tableasy::Table::Cell.new(@andrius, formatter).value.should == helper.link_to('(delete)', @andrius, :method => :delete, :confirm => 'Are you sure?')
    end
  end

  it "should allow creating header cell" do
    formatter = helper.header_column('Hello')
    cell      = Tableasy::Table::Cell.new(@andrius, formatter)
    cell.value.should == 'Hello'
    cell.html[:colspan].should == 2
    cell.header.should == true
  end

  it "should allow creating formatters that take no arguments" do
    formatter = helper.my_edit_link
    Tableasy::Table::Cell.new(@andrius, formatter).value.should == helper.link_to('my edit', [:edit, @andrius])
  end

  describe "headers" do
    it "should allow to create cell with default header" do
      formatter = helper.default_header(:name)
      cell      = Tableasy::Table::Cell.new(Person, formatter)
      cell.value.should == 'Name'
    end
  end

  describe "chaining" do
    it "should allow chaining formatters" do
      build :andrius
      helper.expects(:rand).with(30).returns(17)
      formatter = helper.linked(helper.random(:name, 100..130))
      Tableasy::Table::Cell.new(@andrius, formatter).value.should == '<a href="/people/Andrius">117</a>'
    end

    it "should allow chaining two formatters, that both require initial value" do
      build :andrius
      @andrius.expects(:ages => (20..23).to_a)
      formatter = helper.linked(helper.joined_array(:ages))
      Tableasy::Table::Cell.new(@andrius, formatter).value.should == '<a href="/people/Andrius">20<br />21<br />22<br />23</a>'
    end

    it "should allow chaining headers" do
      formatter = helper.linked(helper.joined_array(:ages)).header
      cell      = Tableasy::Table::Cell.new(Person, formatter)
      cell.value.should == 'Ages'
    end
  end
end
