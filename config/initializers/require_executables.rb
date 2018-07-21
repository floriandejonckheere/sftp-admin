# frozen_string_literal: true

##
# Require certain executables to be present on the system
#

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

# Require ssh-keygen to be installed to validate OpenSSH keys
`which ssh-keygen &> /dev/null`
abort 'Command not found: ssh-keygen. Install ssh-keygen to continue.' unless $?.success?

# Require du to be installed to calculate disk usage
`which du &> /dev/null`
abort 'Command not found: du. Install du to continue.' unless $?.success?
