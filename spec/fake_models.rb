module FakeModel
  extend ActiveSupport::Concern
  include ActiveModel::Conversion

  included do
    extend ActiveModel::Naming  
    def self.human_attribute_name(column)
      column.to_s.humanize
    end
    alias_method :to_s, :name
  end

  def persisted?
    true
  end
end

module FakeModelClass

end

class Person < Struct.new(:id, :name)
  include FakeModel
end

class Project < Struct.new(:id, :name, :leader)
  include FakeModel
end
