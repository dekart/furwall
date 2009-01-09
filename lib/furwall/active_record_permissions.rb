module Furwall
  module ActiveRecordPermissions
    def self.included(base)
      base.class_eval do
        include Furwall::ActiveRecordPermissions::InstanceMethods
        extend  Furwall::ActiveRecordPermissions::ClassMethods

        class << self
          alias_method_chain :permission_for, :base_class
        end

        has_many :permissions, :as => :controllable
      end
    end

    module ClassMethods
      def permission_for_with_base_class(action)
        permission = permission_for_without_base_class(action)

        # Trying to receive access rules from base class
        permission ||= self.base_class.permission_for(action) unless self == self.base_class
        
        return permission
      end
    end

    module InstanceMethods
      def self.included(base)
        base.send(:alias_method_chain, :permission_for, :instance_permissions)
      end

      def permission_for_with_instance_permissions(action)
        permission = self.permissions.detect do |p|
          p.action == action.to_s
        end

        # Trying to receive access rules from class
        permission ||= permission_for_without_instance_permissions(action)

        return permission
      end
    end
  end
end