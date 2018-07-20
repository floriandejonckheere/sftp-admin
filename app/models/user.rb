# frozen_string_literal: true

class User < ApplicationRecord
  ##
  # Properties
  #
  property :name

  ##
  # Associations
  #
  ##
  # Validations
  #
  validates :name,
            :presence => true,
            :uniqueness => true

  ##
  # Callbacks
  #
  ##
  # Methods
  #
  ##
  # Overrides
  #
  ##
  # Helpers and callback methods
  #
end
