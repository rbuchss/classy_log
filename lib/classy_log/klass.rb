module ClassyLog
  module Logging
    module Klass
      CONFIG_PATH = '../../../../../config/'
      CLASSPATH_SPACER = '_'

      def self.included(base)
        base.class_eval do
          include Helper
          include Logging
          extend ClassAttrs
          extend ClassMethods
          load_configs.try(:each) do |key,settings|
            const_set(key, settings)
          end
        end
      end

      module ClassMethods
        # build config_path based on classname
        def config_path
          classpath = name.split('::').map do |bare_name|
            bare_name.gsub(/([A-Z][a-z_0-9]+)/) do |match|
              match.downcase + CLASSPATH_SPACER
            end.chop
          end.join('/')
          full_path = "#{CONFIG_PATH}/#{classpath}.yml"
          File.expand_path(full_path, __FILE__)
        end

        def load_configs
          if File.exists?(config_path)
            config = YAML.load_file(config_path).symbolize_keys
            log.debug config
            config
          else
            log.warn "WARN config file for #{name} not found"
            nil
          end
        end
      end
    end # Klass
  end # Logging
end # ClassyLog
