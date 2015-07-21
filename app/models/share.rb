class Share < ActiveRecord::Base

  has_and_belongs_to_many :users, -> { uniq }

  validates :name, presence: true
  validates :path, presence: true, uniqueness: true, :with => /\/[^\0]*/
  validates :quotum, presence: true

end
