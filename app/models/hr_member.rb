class HrMember < ActiveRecord::Base
  unloadable

  belongs_to :user
end
