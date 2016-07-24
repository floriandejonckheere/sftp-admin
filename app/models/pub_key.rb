require 'key_manager'

class PubKey < ActiveRecord::Base

  belongs_to :user,
                -> { distinct }

  validates :title,
                :presence => true

  validates :key,
                :presence => true

  after_create :update_keys
  after_update :update_keys
  after_destroy :update_keys

  def update_keys
    KeyManager.update_keys
  end

end
