module ClientValidation
  ALLOWES_VALIDATORS = [ActiveRecord::Validations::PresenceValidator]

  RULES_MAPING = {"FormatValidator"=> {jq_rule: ""},"PresenceValidator"=> {jq_rule: "required", error_type: "blank"} }
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
    if !rule.nil? && !validator.options.present?
      case claz
      when "PresenceValidator"
        rules[:required] = true
      # else
      #   rules[:email] = true
      end
      rules[:messages][rule[:jq_rule]] = ActiveModel::Errors.new(self).generate_message(atr, rule[:error_type])
    end
    rules
  end
end

ActiveRecord::Base.send(:include, ClientValidation)