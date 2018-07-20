require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SftpAdmin
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Add `lib` to autoload paths
    config.autoload_paths += %W(#{config.root}/lib)

    config.after_initialize do
      # Check fusequota
      if config.sftp['enable_quotas'] and `fusequota`.nil?
        config.sftp['enable_quotas'] = false
        Rails.logger.warn "The 'fusequota' command was not found, quotas are disabled"
      end
    end
  end
end
