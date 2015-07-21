class User < ActiveRecord::Base

  has_many :pub_keys, dependent: :destroy
  has_and_belongs_to_many :shares, -> { uniq }

  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  validates_format_of :email, :with => /@/

end
