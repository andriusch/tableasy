require File.dirname(__FILE__) + "/../spec_helper"

describe 'Formatters' do
  before do
    build :andrius
  end

  it "should show linked object" do
    formatter = helper.linked(:name)
    formatter.to_sym.should == :name
    formatter.execute(@andrius).should == '<a href="/people/Andrius">Andrius</a>'
  end

  it "should show object linked to itself" do
    build :project
    formatter = helper.linked_to(:leader)
    formatter.to_sym.should == :leader
    formatter.execute(@project).should == '<a href="/people/Andrius">Andrius</a>'
  end

  it "should show nothing when linked object doesn't exist" do
    build :project
    @project.leader = nil
    formatter = helper.linked_to(:leader)
    formatter.to_sym.should == :leader
    formatter.execute(@project).should == ''
  end

  it "should show number with percent" do
    @andrius.stubs(:work_hours).returns(100, 100, 13, nil)
    @andrius.stubs(:remaining).returns(8, -8, 8, nil)

    formatter = helper.with_percent(:remaining, :work_hours)
    formatter.to_sym.should == :remaining
    ["8 (8.000%)", "-8 (-8.000%)", "8 (61.538%)", "0 (0.000%)"].each do |result|
      formatter.execute(@andrius).should == result
    end
  end

  it "should return random number in range" do
    helper.expects(:rand).with(30).returns(23)
    formatter = helper.random(:hours, 100..130)
    formatter.to_sym.should == :hours
    formatter.execute(nil).should == 123
  end

  describe 'tail_link' do
    before do
      build :andrius
    end

    it "should allow show link with no symbol" do
      formatter = helper.tail_link('hello')
      formatter.execute(@andrius).should == '<a href="/people/Andrius">hello</a>'
      formatter.to_sym.should == nil
    end

    it "should allow passing custom url" do
      formatter = helper.tail_link('hello', :edit)
      formatter.execute(@andrius).should == '<a href="/edit/people/Andrius">hello</a>'
    end

    it "should allow passing custom url and html attributes" do
      formatter = helper.tail_link('hello', :edit, :method => :delete)
      formatter.execute(@andrius).should == helper.link_to('hello', [:edit, @andrius], :method => :delete)
    end

    it "should allow creating ajax link" do
      formatter = helper.tail_link('hello', :edit, :ajax => true)
      formatter.execute(@andrius).should == helper.link_to_remote('hello', :url => [:edit, @andrius])
    end
  end
end
