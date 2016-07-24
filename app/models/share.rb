class Share < ActiveRecord::Base

  has_and_belongs_to_many :users,
                            -> { distinct }

  validates :name,
              :presence => true
  validates :path,
              :presence => true,
              :uniqueness => true
  validates_format_of :path,
                        :with => /[^\0]*/
  validates :quota,
              :presence => true

  validate :path_subdir_of_storage_path

  before_validation :resolve_path
  after_create :create_storage_directory
  after_destroy :delete_storage_directory

  # Dummy quota_unit attribute
  def quota_unit
  end

  def quota_unit=(unit)
    p "#{self.quota} #{unit}"
    self.quota = Filesize.from("#{self.quota} #{unit}").to_i
  end

  #
  # Methods
  #

  # Returns quota or false (disabled either globally or per share)
  def quota?
    (self.quota && self.quota != 0 && Rails.application.config.sftp['enable_quotas']) ? self.quota : false
  end

  # Returns full directory path
  def full_path
    File.expand_path(File.join(Rails.application.config.sftp['storage_path'], path))
  end

  # Recalculate disk usage
  def recalculate_usage
    usage = `du -bs "#{self.full_path}"`.split('\t').first.to_i
    update :size => usage
  end

  def create_storage_directory
    if File.exists?(full_path)
      errors.add :path, "File or directory #{full_path} already exists"
      return false
    end
    FileUtils.mkdir_p(full_path)
  end

  def delete_storage_directory
    FileUtils.rm_rf(full_path)
  end

  def path_subdir_of_storage_path
    unless full_path.start_with? Rails.application.config.sftp['storage_path']
      errors.add :path, 'must be a subdirectory of the storage path'
    end
  end

  def resolve_path
    self.path = full_path[Rails.application.config.sftp['storage_path'].length..-1] || ''
  end
end
