module Furwall
  module ModulePermissions
    def self.included(base)
      base.send(:include, InstanceMethods)

      base.send(:attr_accessor, :permission_references)
    end

    module InstanceMethods
      def permission_reference(*attrs)
        self.permission_references = attrs.collect{|a| a.to_sym }
      end

      def permission_reference_by_key(key)
        if key.blank?
          self
        elsif self.permission_references and self.permission_references.include?(key.to_sym)
          send(key)
        else
          nil
        end
      end

      def permission_for(action)
        Permission.by_controllable_type(self).detect do |p|
          p.action == action.to_s
        end
      end
    end
  end
end