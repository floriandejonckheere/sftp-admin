# frozen_string_literal: true

class SFTPShell
  class AccessDeniedError < StandardError; end
  class DisallowedCommandError < StandardError; end
  class InvalidSharePathError < StandardError; end
end
