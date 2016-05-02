require "classy_log/version"
require "classy_log/class_attrs"
require "classy_log/logging"

module ClassyLog
  def self.included(base)
    base.include Logging
  end
end
