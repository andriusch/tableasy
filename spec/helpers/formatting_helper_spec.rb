require File.dirname(__FILE__) + "/../spec_helper"

describe 'Formatters' do
  before do
    build :andrius
  end

  it "should show linked object" do
    formatter = helper.linked(:name)
    formatter.to_sym.should == :name
    Tableasy::Table::Cell.new(@andrius, formatter).value.should == '<a href="/people/Andrius">Andrius</a>'
  end

  it "should show object linked to itself" do
    build :project
    formatter = helper.linked_to(:leader)
    formatter.to_sym.should == :leader
    Tableasy::Table::Cell.new(@project, formatter).value.should == '<a href="/people/Andrius">Andrius</a>'
  end

  it "should show nothing when linked object doesn't exist" do
    build :project
    @project.leader = nil
    formatter = helper.linked_to(:leader)
    formatter.to_sym.should == :leader
    Tableasy::Table::Cell.new(@project, formatter).value.should == ''
  end

  it "should show number with percent" do
    @andrius.stubs(:work_hours).returns(100, 100, 13, nil)
    @andrius.stubs(:remaining).returns(8, -8, 8, nil)

    formatter = helper.with_percent(:remaining, :work_hours)
    formatter.to_sym.should == :remaining
    ["8 (8.000%)", "-8 (-8.000%)", "8 (61.538%)", "0 (0.000%)"].each do |result|
      Tableasy::Table::Cell.new(@andrius, formatter).value.should == result
    end
  end

  it "should return random number in range" do
    helper.expects(:rand).with(30).returns(23)
    formatter = helper.random(:hours, 100..130)
    formatter.to_sym.should == :hours
    Tableasy::Table::Cell.new(nil, formatter).value.should == 123
  end

  describe 'tail_link' do
    before do
      build :andrius
    end

    it "should allow show link with no symbol" do
      formatter = helper.tail_link('hello')
      Tableasy::Table::Cell.new(@andrius, formatter).value.should == '<a href="/people/Andrius">hello</a>'
      formatter.to_sym.should == nil
    end

    it "should allow passing custom url" do
      formatter = helper.tail_link('hello', :edit)
      Tableasy::Table::Cell.new(@andrius, formatter).value.should == '<a href="/edit/people/Andrius">hello</a>'
    end

    it "should allow passing custom url and html attributes" do
      formatter = helper.tail_link('hello', :edit, :method => :delete)
      Tableasy::Table::Cell.new(@andrius, formatter).value.should == helper.link_to('hello', [:edit, @andrius], :method => :delete)
    end

    it "should allow creating ajax link" do
      formatter = helper.tail_link('hello', :edit, :ajax => true)
      Tableasy::Table::Cell.new(@andrius, formatter).value.should == helper.link_to_remote('hello', :url => [:edit, @andrius])
    end

    it "should allow creating edit url" do
      formatter = helper.edit_link('(edit)')
      Tableasy::Table::Cell.new(@andrius, formatter).value.should == helper.link_to('(edit)', [:edit, @andrius])
    end

    it "should allow creating ajax edit url" do
      formatter = helper.edit_link('(edit)', :ajax => true)
      Tableasy::Table::Cell.new(@andrius, formatter).value.should == helper.link_to_remote('(edit)', :url => [:edit, @andrius], :method => :get)
    end

    it "should allow creating delete link" do
      formatter = helper.destroy_link('(delete)')
      Tableasy::Table::Cell.new(@andrius, formatter).value.should == helper.link_to('(delete)', @andrius, :method => :delete, :confirm => 'Are you sure?')
    end
  end

  it "should allow creating header cell" do
    formatter = helper.header_row('Hello')
    cell = Tableasy::Table::Cell.new(@andrius, formatter)
    cell.value.should == 'Hello'
    cell.html[:colspan].should == 2
    cell.header.should == true
  end
end
