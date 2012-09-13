class Setting < ActiveRecord::Base
  validates_presence_of :name, :value, :description
  validates_uniqueness_of :name
end
