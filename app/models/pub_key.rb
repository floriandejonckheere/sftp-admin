require 'key_manager'

class PubKey < ActiveRecord::Base

  belongs_to :user,
                -> { distinct }

  validates :title,
                :presence => true

  validates :key,
                :presence => true

  after_create :add_key
  after_update :update_key
  before_destroy :remove_key

  def add_key
    p self.id
    KeyManager.add_key(self.id)
  end

  def remove_key
    KeyManager.remove_key(self.id)
  end

  def update_key
    self.remove_key
    self.add_key
  end

end
