# frozen_string_literal: true

module SFTPShell
  class AccessDeniedError < StandardError; end
  class DisallowedCommandError < StandardError; end
  class InvalidSharePathError < StandardError; end
  class ServerError < StandardError; end
end
