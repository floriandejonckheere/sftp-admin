# frozen_string_literal: true

# Require fusequota to be installed when quotas are enabled
if Rails.application.config.sftp['features']['quotas']
  `which fusequota &> /dev/null`
  abort 'Command not found: fusequota. Install fusequota or disable quotas in config/sftp.yml.' unless $?.success?
end

# Require encfs to be installed when encryption is enabled
if Rails.application.config.sftp['features']['encryption']
  `which encfs &> /dev/null`
  abort 'Command not found: encfs. Install encfs or disable encryption in config/sftp.yml.' unless $?.success?
end

`which ssh-keygen &> /dev/null`
abort 'Command not found: ssh-keygen. Install ssh-keygen to continue.' unless $?.success?
