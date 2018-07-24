# frozen_string_literal: true

##
# Require certain executables to be present on the system
#

# Require fusequota to be installed when quotas are enabled
if Rails.application.config.sftp['features']['quotas']
  `which fusequota &> /dev/null`

  unless $CHILD_STATUS.success?
    abort 'Command not found: fusequota. Install fusequota or disable quotas in config/sftp.yml.'
  end
end

# Require encfs to be installed when encryption is enabled
if Rails.application.config.sftp['features']['encryption']
  `which encfs &> /dev/null`

  $CHILD_STATUS.success? || abort('Command not found: encfs. Install encfs or disable encryption in config/sftp.yml.')
end

# Require ssh-keygen to be installed to validate OpenSSH keys
`which ssh-keygen &> /dev/null`

$CHILD_STATUS.success? || abort('Command not found: ssh-keygen. Install ssh-keygen to continue.')

# Require du to be installed to calculate disk usage
`which du &> /dev/null`

$CHILD_STATUS.success? || abort('Command not found: du. Install du to continue.')
