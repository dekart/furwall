module Furwall
  module ObjectPermissions
    def self.included(base)
      base.send(:extend, ClassMethods)
      base.send(:include, InstanceMethods)

      base.send(:cattr_accessor, :available_permission_references)
    end

    module ClassMethods
      def permission_for(action)
        permission = Permission.by_controllable_type(self).detect do |p|
          p.action == action.to_s
        end

        return permission
      end

      def permission_reference(*attrs)
        self.available_permission_references = attrs.collect{|a| a.to_sym }
      end
    end

    module InstanceMethods
      def permission_references
        self.class.available_permission_references || []
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
        # Trying to receive access rules from class
        permission ||= self.class.permission_for(action)
      end
    end
  end
end