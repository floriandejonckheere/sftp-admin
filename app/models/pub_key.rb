require 'key_manager'

class PubKey < ActiveRecord::Base

  belongs_to :user, -> { uniq }

  validates :title, presence: true
  # TODO: key format validation
  validates :key, presence: true

  after_create :add_key
  after_update :update_key
  before_destroy :rm_key

  def add_key
    p self.id
    KeyManager.add_key(self.id)
  end

  def rm_key
    KeyManager.rm_key(self.id)
  end

  def update_key
    self.rm_key
    self.add_key
  end

end
