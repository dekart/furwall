module Furwall
  module ControllerExtensions
    def self.included(base)
      if base.respond_to? :helper_method
        base.helper_method(:object_permit?)
        base.helper_method(:object_restrict_to)
      end
    end

    protected

    def object_access_handler
      @object_access_handler ||= Furwall::AccessHandler.new
    end

    def check_object_permissions!(*args)
      return if object_permit?(*args)

      raise Furwall::PermissionDenied.new("Permission denied for object")
    end

    def object_permit?(*args)
      context = access_context(args.extract_options!)
      object  = args.shift
      action  = args.shift || params[:action]

      permission = object.permission_for(action)

      return false if permission.nil? || context[:user].nil?

      object_access_handler.process(permission.rule, context.merge(:object => object))
    end

    def object_restrict_to(*args)
      returning result = '' do
        if object_permit?(*args)
          result << yield if block_given?
        end
      end
    end
  end
end