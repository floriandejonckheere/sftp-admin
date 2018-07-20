# frozen_string_literal: true

require 'key_manager'

class Key < ApplicationRecord
  ##
  # Properties
  #
  property :title
  property :key

  ##
  # Associations
  #
  belongs_to :user

  ##
  # Validations
  #
  validates :title,
            :presence => true

  validates :key,
            :presence => true

  validates :user,
            :presence => true

  ##
  # Callbacks
  #
  after_create :update_keys
  after_update :update_keys
  after_destroy :update_keys

  ##
  # Methods
  #
  ##
  # Overrides
  #
  ##
  # Helpers and callback methods
  #
  def update_keys
    KeyManager.update_keys
  end
end
