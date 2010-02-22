module FakeModel
end

module FakeModelClass
  def human_attribute_name(column)
    column.to_s.humanize
  end
end

class Person < Struct.new(:id, :name)
  alias_method :to_s, :name
  extend FakeModelClass
end

class Project < Struct.new(:id, :name, :leader)
  alias_method :to_s, :name
  extend FakeModelClass
end
