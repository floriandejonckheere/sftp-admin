class PubKey < ActiveRecord::Base

  belongs_to :user, -> { uniq }

  validates :title, presence: true
  validates :key, presence: true
  validates :fingerprint, presence: true

end
