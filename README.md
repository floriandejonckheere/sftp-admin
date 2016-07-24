# sftp-admin

sftp-admin is a tool to provide sftp, scp and rsync access to a server for many users. It leverages a gitolite-like system to authenticate and authorize user read/write access to directories (called shares). It is intended to be used as a centralized administration system, hence the web frontend is not accessible for non-admins.

sftp-admin is split into three components: the frontend web application (including REST API), a Ruby on Rails application. The `sftpadmd` (v2.0 or higher) daemon takes care of the filesystem operations such as mounting, calculating disk usage, managing quotas (v2.0 or higher) and managing encryption (v3.0 or higher).

The last component is the only component a user typically interacts with: a login shell. It allows or denies read/write access based on predefined rules.

## Installation

sftp-admin requires the following components:
- `fusequota` if you wish to use the quota feature (v2.0 or higher)
- `encFS` if you wish to use the encryption feature (v3.0 or higher)
- A properly configured SSH server that uses the `~/.ssh/authorized_keys` mechanism (OpenSSH)
- The `du` utility for calculating disk usage

## Setup

For safety reasons, create a user under which the application should run -- for example `sftp`. It is recommended to set the storage path to a directory under the user's home directory.

```
# useradd --home-dir /home/sftp sftp
```

Make sure this user has SSH permission (commonly achieved by adding it to the `sshusers` group). Then create the appropriate files and folders for this user (see `config.yml`).

```
# sudo -u sftp -H mkdir -p ~/.ssh/ ~/storage/
```

A cron scheduler was included to periodically recalculate disk usage. Run the following command to automatically update the crontab.

```
# sudo -u sftp -H whenever --update-crontab
```

## Roadmap

**v1.0**

- Support for creating users, shares and assigning shares to users (ro or rw).
- Support for accessing assigned shares
- Admin authentication

**v2.0**

- Support for share-level quotas

**v3.0**

- Support for share-level encryption
