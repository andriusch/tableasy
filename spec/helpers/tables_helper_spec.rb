require File.dirname(__FILE__) + "/../spec_helper"

describe Tableasy::TablesHelper do
  it "should allow creating table for collection of models" do
    build :project
    output = helper.table_for(Project, [@project], :name)

    output.should == "<table><tr><th>Name</th></tr><tr class=\"project odd\" id=\"row_project_1\"><td>project</td></tr></table>"
  end

  it "should yield row object with columns and record when creating table using block" do
    build :project
    output = helper.table_for(Project, [@project], :name, :leader) do |row|
      row.cells[0].value = row.cells[0].subject.name
      row.cells[1].value = 'xxxxx'
    end

    output.should == "<table><tr><th>Name</th><th>Leader</th></tr><tr class=\"project odd\" id=\"row_project_1\"><td>project</td><td>xxxxx</td></tr></table>"
  end

  it "should allow passing custom html options for row and columns" do
    build :project
    output = helper.table_for(Project, [@project], :name) do |row|
      row.html[:class] = 'my-row'
      row.cells[0].html[:class] = 'name'
    end

    output.should == "<table><tr><th>Name</th></tr><tr class=\"my-row\" id=\"row_project_1\"><td class=\"name\">project</td></tr></table>"
  end

  it "should allow creating a table with totals row" do
    build :admin, :andrius
    output = helper.table_for(Person, [@admin, @andrius], :name, :id, :total => true)

    output.should == "<table>\
<tr><th>Name</th><th>Id</th></tr>\
<tr class=\"person odd\" id=\"row_person_1\"><td>Admin</td><td>1</td></tr>\
<tr class=\"person even\" id=\"row_person_1\"><td>Andrius</td><td>1</td></tr>\
<tr class=\"total-row\"><th>Total: </th><td>2</td></tr>\
</table>"
  end

  it "should allow creating custom total row" do
    build :admin, :andrius
    output = helper.table_for(Person, [@admin, @andrius], :name, :id, :total => true) do |row|
      row.cells[0].value = 'Total of:' if row.total_row?
      row.cells[1].value = "@#{row.cells[1].subject.id}"
    end

    output.should == "<table>\
<tr><th>Name</th><th>Id</th></tr>\
<tr class=\"person odd\" id=\"row_person_1\"><td>Admin</td><td>@1</td></tr>\
<tr class=\"person even\" id=\"row_person_1\"><td>Andrius</td><td>@1</td></tr>\
<tr class=\"total-row\"><th>Total of:</th><td>@2</td></tr>\
</table>"
  end

  it "should allow using formatters" do
    build :andrius
    output = helper.table_for(Person, [@andrius], helper.linked(:name))

    output.should == "<table><tr><th>Name</th></tr><tr class=\"person odd\" id=\"row_person_1\"><td><a href=\"/people/Andrius\">Andrius</a></td></tr></table>"
  end

  it "should allow using formatters with totals" do
    build :andrius, :admin
    @andrius.stubs(:id2).returns(@andrius.id * 2)
    @admin.stubs(:id2).returns(@admin.id * 2)
    output = helper.table_for(Person, [@admin, @andrius], :name, :id2, helper.with_percent(:id, :id2), :total => true)

    output.should == "<table>\
<tr><th>Name</th><th>Id2</th><th>Id</th></tr>\
<tr class=\"person odd\" id=\"row_person_1\"><td>Admin</td><td>2</td><td>1 (50.000%)</td></tr>\
<tr class=\"person even\" id=\"row_person_1\"><td>Andrius</td><td>2</td><td>1 (50.000%)</td></tr>\
<tr class=\"total-row\"><th>Total: </th><td>4</td><td>2 (50.000%)</td></tr>\
</table>"
  end

  it "should allow passing custom html options to table" do
    build :project
    output = helper.table_for(Project, [@project], :name, :html => {:id => 'my_table'})
    output.should == "<table id=\"my_table\"><tr><th>Name</th></tr><tr class=\"project odd\" id=\"row_project_1\"><td>project</td></tr></table>"
  end

  describe 'data list' do
    it "should allow building data list" do
      build :andrius
      output = helper.data_list(@andrius, :name, :id)

      output.should == "<table><tr><th>Name</th><td>Andrius</td></tr><tr><th>Id</th><td>1</td></tr></table>"
    end
  end
end
