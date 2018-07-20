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
  ##
  # Validations
  #
  validates :name,
            :presence => true

  validates :path,
            :presence => true,
            :uniqueness => true,
            :format => { :with => /[^\0]*/ }

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
    return false if quota == 0
    return false unless Rails.application.config.sftp['enable_quotas']

    true
  end

  # Recalculate disk usage
  def recalculate_usage!
    usage = `du -bs "#{full_path}"`.split('\t').first.to_i
    update :size => usage
  end

  ##
  # Overrides
  #
  ##
  # Helpers and callback methods
  #
  def path_subdir_of_storage_path
    unless full_path.start_with? Rails.application.config.sftp['storage_path']
      errors.add :path, 'must be a subdirectory of the storage path'
    end
  end

  # Returns full storage path
  def full_path
    File.expand_path File.join Rails.application.config.sftp['storage_path'], path
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
