require 'rails_jq_validations/util'
module ClientValidation
  ALLOWES_VALIDATORS = [ActiveRecord::Validations::PresenceValidator]

  RULES_MAPING = {"NumericalityValidator"=>{jq_rule: "number", error_type: :not_a_number}, "FormatValidator"=> {jq_rule: "regex", error_type: "invlaid"},"PresenceValidator"=> {jq_rule: "required", error_type: "blank"} }
  extend ActiveSupport::Concern

  def jq_validation_rules(atr)
    rules = {messages: {}}
    validators = self.class.try(:_validators)
    validators = validators.select{|k,v|k==atr.to_sym}.first.try(:[],1) if validators
    return rules unless validators
    validators.each do |validator|
      rules = add_jq_rule(rules, validator,atr)
    end
    rules
  end

  def add_jq_rule(rules, validator, atr)
    claz = "#{validator.class}".split("::").last
    rule = RULES_MAPING[claz]
    puts "*"*100
    puts claz
    # debugger
    if !rule.nil? && ![:if, :unless].any?{|cond| validator.options[cond].present? } #validator.options[:if].present?
      case claz
      when "PresenceValidator"
        rules[:required] = true
      when "FormatValidator"
        rules[:regex] = Util.json_regexp(validator.options[:with])
      when "NumericalityValidator"
        # debugger
        if validator.options[:only_integer]
          rules[:integer]= true
        else
          rules[:number] = true
        end

      # else
      #   rules[:email] = true
      end
      rules[:messages][rule[:jq_rule]] = ActiveModel::Errors.new(self).generate_message(atr, rule[:error_type])
    end
    rules
  end

  module ClassMethods

  end
end

ActiveRecord::Base.send(:include, ClientValidation)