# frozen_string_literal: true

class Share < ApplicationRecord
  ##
  # Properties
  #
  property :name
  property :path
  property :quota
  property :size

  ##
  # Associations
  #
  has_and_belongs_to_many :users,
                          -> { distinct }

  ##
  # Validations
  #
  validates :name,
            :presence => true

  validates :path,
            :presence => true,
            :uniqueness => true,
            :format => { :with => /\A[^\0]*\z/ }

  validates :quota,
            :presence => true

  validate :path_subdir_of_storage_path

  ##
  # Callbacks
  #
  before_validation :resolve_path
  after_create :create_storage
  after_destroy :delete_storage

  ##
  # Methods
  #
  # Returns false if quota is disabled (globally or per share)
  def quota?
    return false unless quota
    return false if quota.zero?
    return false unless Rails.application.config.sftp['enable_quotas']

    true
  end

  # Recalculate disk usage of share
  def recalculate_usage!
    usage = `du -bs "#{full_path}"`.split('\t').first.to_i
    update :size => usage
  end

  # Recalculate disk usage of all shares
  def self.recalculate_all_usage!
    Share.all.each(&:recalculate_usage!)
  end

  ##
  # Overrides
  #
  ##
  # Helpers and callback methods
  #
  def path_subdir_of_storage_path
    return if full_path.start_with? Rails.application.config.sftp['storage_path']

    errors.add :path, 'must be a subdirectory of the storage path'
  end

  # Returns full storage path
  def full_path
    File.expand_path File.join Rails.application.config.sftp['storage_path'], path || ''
  end

  def resolve_path
    self.path = full_path[Rails.application.config.sftp['storage_path'].length..-1] || ''
  end

  # Create storage path
  def create_storage
    if File.exist? full_path
      errors.add :path, "File or directory '#{full_path}' already exists"
      return false
    end

    FileUtils.mkdir_p full_path
  end

  # Delete storage path and its contents
  def delete_storage
    FileUtils.rm_r full_path, :secure => true
  end
end
