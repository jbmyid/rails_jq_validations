module ActionView
  module Helpers
    module Tags
      [RadioButton,TextField, TextArea, CheckBox, Select].each do |kls|
        kls.class_eval do
          def render_with_jq_rules
            @options[:data] ||= {}
            @options[:data][:jq_rules] ||= object.jq_validation_rules(@method_name)
            render_without_jq_rules
          end
          alias_method_chain :render, :jq_rules
        end
      end
    end
  end
end