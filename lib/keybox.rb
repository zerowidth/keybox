require 'keybox/randomizer'
require 'keybox/string_generator'
require 'keybox/password_hash'
module Keybox
    VERSION = '1.0.0'
    APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__),".."))
    APP_RESOURCE_DIR = File.join(APP_ROOT,"resource")
end
