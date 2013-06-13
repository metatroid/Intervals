class Project < ActiveRecord::Base
  belongs_to :user
  has_many :intervals, :dependent => :destroy
  has_many :invoices, :dependent => :destroy
  mount_uploader :projectlogo, ProjectlogoUploader
end
