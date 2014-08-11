#=require "rails_jq_validations/jquery.validation.min"
#=require "rails_jq_validations/validators"

@FormValidator = (form) ->
  @forms = form or $("form[data-validate=true]")
  @setDefaults = ->
    $.validator.setDefaults errorElement: "span"
    $.extend jQuery.validator.messages,
      required: "Mandatory Field"

  @validateForms = (f) ->
    f.validate()

  # "data-rules"=>{messages: {required: 'Required input'}}.to_json
  @setRules = (newRules) ->
    $("input", @forms).each (i, v) ->
      ele = $(v)
      rules = newRules or ele.data("jq-rules")
      ele.rules "add", rules  if rules
  @setAll = ->
    @setDefaults()
    @validateForms @forms
    @setRules()

  @setAll()
$ ->
  validator = new FormValidator()
