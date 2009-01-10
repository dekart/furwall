module Furwall
  module ObjectPermissions
    def self.included(base)
      base.send(:extend, ClassMethods)
      base.send(:include, InstanceMethods)

      base.send(:cattr_accessor, :permission_references)
    end

    module ClassMethods
      def permission_for(action)
        Permission.by_controllable_type(self).detect do |p|
          p.action == action.to_s
        end
      end

      def permission_reference(*attrs)
        self.permission_references = attrs.collect{|a| a.to_sym }
      end
    end

    module InstanceMethods
      def permission_reference_by_key(key)
        if key.blank?
          self
        elsif self.class.permission_references and self.class.permission_references.include?(key.to_sym)
          send(key)
        else
          nil
        end
      end

      def permission_for(action)
        # Fetching class permissions
        self.class.permission_for(action)
      end
    end
  end
end