module Furwall
  class IncorrectAccessRule < Exception
  end

  class ObjectNotDefined < Exception
  end

  class AccessHandler < Caboose::AccessHandler
    def check(key, context)
      raise Furwall::ObjectNotDefined.new("Object for permission check not specified") unless context[:object]

      if key.include?(":")  # State-based permission
        reference_key, state = key.split(":")


        with_permission_reference(context[:object], reference_key) do |reference|
          if reference.respond_to?("#{state}?")
            Rails.logger.debug("Checking state :#{state} for #{reference.inspect}")

            return reference.send("#{state}?")
          else
            raise IncorrectAccessRule.new("Wrong state for #{reference.inspect}: #{state}")
          end
        end

      elsif key.include?(".") # Custom object role permission
        reference_key, role = key.split(".")

        with_permission_reference(context[:object], reference_key) do |reference|
          if reference.respond_to?("is_#{role}?", context[:user])
            Rails.logger.debug("Checking custom role :#{role} for #{reference.inspect}")

            return reference.send("is_#{role}?", context[:user])
          else
            raise IncorrectAccessRule.new("Wrong user relation for #{reference.inspect}: #{role}")
          end
        end
      else
        Rails.logger.debug("Checking basic role '#{key}'")
        # Basic user roles
        return context[:user].roles.map{ |role| role.title.downcase}.include?(key)
      end
    end
    
    protected

    def with_permission_reference(object, key)
      if object.respond_to?(:permission_reference_by_key)
        if reference = object.permission_reference_by_key(key)
          yield(reference)
        else
          raise IncorrectAccessRule.new(
            "Trying to reference property that is not permitted: #{reference_key}"
          )
        end
      else
        raise IncorrectAccessRule.new(
          "Object cannot be used with state and custom-role permissions: \n#{object.inspect}"
        )
      end
    end
  end
end