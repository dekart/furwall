require File.join(File.dirname(__FILE__), "lib", "furwall", "access_handler")
require File.join(File.dirname(__FILE__), "lib", "furwall", "permissions")
require File.join(File.dirname(__FILE__), "app", "models", "permission")

ActiveRecord::Base.send(:include, Furwall::Permissions)
ActionController::Base.send(:include, Furwall::ControllerExtensions)
