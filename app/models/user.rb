# frozen_string_literal: true

class User < ApplicationRecord
  ##
  # Properties
  #
  property :name

  ##
  # Associations
  #
  has_and_belongs_to_many :shares,
                          -> { distinct }

  has_many :keys,
           :dependent => :destroy

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
