$.validator.addMethod "regex", ((value, element, regexp) ->
  re = new RegExp(regexp)
  @optional(element) or re.test(value)
), "Please check your input."

$.validator.addMethod "integer", ((value, element, param) ->
  (value is parseInt(value, 10))
), "Please enter a integer value!"