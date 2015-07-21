# sftp-admin

sftp-admin is a tool to provide sftp, scp and rsync access to a server for many users. It leverages a gitolite-like system to authenticate and authorize user read/write access to directories (called shares).

sftp-admin provides two components: the frontend admin panel, which is a Ruby on Rails project, and the login shell, which is plain Ruby.

## Installation

sftp-admin requires the following components:
- `Ruby` >= ???
- `fusequota` if you wish to use the quota feature
- ~~`encFS` if you wish to use the encryption feature~~ rsyncrypto should be used for now
- A properly configured SSH server that uses the `~/.ssh/authorized_keys` mechanism (OpenSSH)

## Setup

First, create a user under which the application should run -- for example `sftp`.

```
# useradd --home-dir /home/sftp sftp
```

Make sure this user has SSH permission (commonly achieved by adding it to the `sshusers` group).
