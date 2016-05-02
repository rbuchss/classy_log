module ClassyLog
  module ClassAttrs
    def class_attr_reader(*vars)
      vars.each do |var|
        define_singleton_method(var) do
          class_variable_get("@@#{var}")
        end
      end
    end

    def class_attr_writer(*vars)
      vars.each do |var|
        define_singleton_method("#{var}=") do |arg|
          class_variable_set("@@#{var}", arg)
        end
      end
    end

    def class_attr_accessor(*vars)
      class_attr_reader(*vars)
      class_attr_writer(*vars)
    end
  end # ClassAttrs
end # ClassyLog
