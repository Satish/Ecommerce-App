module ActiveRecord
  class Base
    def self.required_attributes
      @required_attributes ||= []
    end

    def self.validates_presence_of(*attr_names)
      @required_attributes = attr_names.collect{|attr| attr if attr.is_a?(Symbol)}.compact
      super
    end
  end
end