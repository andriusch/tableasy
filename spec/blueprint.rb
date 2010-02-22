blueprint :andrius do
  Person.new(1, 'Andrius')
end

blueprint :admin do
  Person.new(1, 'Admin')
end

blueprint :project => :andrius do
  Project.new(1, 'project', @andrius)
end
