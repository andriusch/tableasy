class Person < Struct.new(:name)
  alias :to_s :name
end

class Project < Struct.new(:name, :leader)
  alias :to_s :name
end
