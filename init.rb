require File.join(File.dirname(__FILE__), "lib", "furwall", "access_handler")
require File.join(File.dirname(__FILE__), "app", "models", "permission")

Object.send(:include, Furwall::ObjectPermissions)
Module.send(:include, Furwall::ModulePermissions)
ActiveRecord::Base.send(:include, Furwall::ActiveRecordPermissions)

ActionController::Base.send(:include, Furwall::ControllerExtensions)
