class Share < ActiveRecord::Base

  SIZES = ['B', 'KB', 'KiB', 'MB', 'MiB', 'GB', 'GiB', 'TB', 'TiB', 'PB', 'PiB']

  has_and_belongs_to_many :users, -> { uniq }

  validates :name, presence: true
  validates :path, presence: true, uniqueness: true
  validates_format_of :path, :with => /[^\0]*/
  validates :quota, presence: true

  # Dummy quota_unit attribute
  def quota_unit
  end
  def quota_unit=(unit)
    p "#{self.quota} #{unit}"
    self.quota = Filesize.from("#{self.quota} #{unit}").to_i
  end

  before_create :create_storage_directory
  after_destroy :delete_storage_directory

  #
  # Methods
  #

  # Returns quota or false (disabled)
  def quota?
    return self.quota if (self.quota != 0 && Rails.application.config.sftp['quota_enabled'])
    return false
  end

  # Returns full directory path
  def full_path
    return File.join(Rails.application.config.sftp['storage_path'], path)
  end

  # Recalculate disk usage
  def usage
    # TODO: cross-reference du params with fusequota for correct measuring
    usage = `du -bs "#{self.full_path}"`.split("\t").first.to_i
    update(:size => usage)
    return usage
  end

  def create_storage_directory
    if File.exists?(full_path)
      errors.add :path, "File or directory #{full_path} already exists"
      return false
    end
    FileUtils.mkdir_p full_path
  end

  def delete_storage_directory
    FileUtils.rm_rf(full_path)
  end

  def quota_parseable_size

  end
end
