require File.join(File.dirname(__FILE__), "lib", "furwall", "access_handler")
require File.join(File.dirname(__FILE__), "lib", "furwall", "active_record_permissions")
require File.join(File.dirname(__FILE__), "app", "models", "permission")

Object.send(:include, Furwall::ObjectPermissions)
ActiveRecord::Base.send(:include, Furwall::ActiveRecordPermissions)
ActionController::Base.send(:include, Furwall::ControllerExtensions)
