require 'rails_jq_validations/util'
module ClientValidation
  ALLOWES_VALIDATORS = [ActiveRecord::Validations::PresenceValidator]

  RULES_MAPING = {"ExclusionValidator"=> {jq_rule: "exclusion", error_type: :exclusion},"LengthValidator"=> {jq_rule: nil, error_type: :length},"InclusionValidator"=> {jq_rule: "inclusion", error_type: :inclusion},"NumericalityValidator"=>{jq_rule: "number", error_type: :not_a_number}, "FormatValidator"=> {jq_rule: "regex", error_type: "invlaid"},"PresenceValidator"=> {jq_rule: "required", error_type: "blank"} }
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
    val_options = validator.options
    claz = "#{validator.class}".split("::").last
    rule = RULES_MAPING[claz]
    if !rule.nil? && ![:if, :unless].any?{|cond| val_options[cond].present? }
      case claz
      when "PresenceValidator"
        rules[:required] = true
      when "FormatValidator"
        rules[:regex] = Util.json_regexp(val_options[:with])
      when "NumericalityValidator"
        rules[:number] = true
        rules[:integer]= true if val_options[:only_integer]
        [:greater_than_or_equal_to, :greater_than, :equal_to, :less_than, :less_than_or_equal_to, :odd, :even].each do |val_opt|
          if val_options[val_opt]
            rules[val_opt] = val_options[val_opt]
            rules[:messages][val_opt] = errors.generate_message(atr, val_opt, count: val_options[val_opt])
          end
        end
      when "InclusionValidator"
        rules[:inclusion] = val_options[:in].map(&:to_s)
      when "ExclusionValidator"
        rules[:exclusion] = val_options[:in].map(&:to_s)
      when "LengthValidator"
        [:is, :minimum, :maximum].each do |val_opt|
          rules["length_#{val_opt}"] = val_options[val_opt] if val_options[val_opt]
        end
      end
      rules[:messages][rule[:jq_rule]] = errors.generate_message(atr, rule[:error_type]) if rule[:jq_rule].present?
    end
    rules
  end

  def add_jq_error_messages
    {presence: {message_type: "blank", jq_rule: "required"}, length: {message_type: "",opts: {minimum: true}}}
  end

  module ClassMethods

  end
end

ActiveRecord::Base.send(:include, ClientValidation)