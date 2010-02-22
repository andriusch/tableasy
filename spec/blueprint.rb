blueprint :andrius do
  Person.new('Andrius')
end

blueprint :project => :andrius do
  Project.new('project', @andrius)
end
