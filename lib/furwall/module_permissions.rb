module Furwall
  module ModulePermissions
    def self.included(base)
      base.send(:extend, ClassMethods)
      base.send(:include, InstanceMethods)

      base.send(:attr_accessor, :available_permission_references)
    end

    module InstanceMethods
      def permission_reference(*attrs)
        self.available_permission_references = attrs.collect{|a| a.to_sym }
      end

      def permission_references
        self.available_permission_references || []
      end

      def permission_reference_by_key(key)
        if key.blank?
          self
        elsif permission_references.include?(key.to_sym)
          send(key)
        else
          nil
        end
      end

      def permission_for(action)
        permission ||= self.class.permission_for(action)
      end
    end
  end
end