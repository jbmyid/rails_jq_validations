blank = (val) ->
  $.trim(val).length==0
$.validator.addMethod "regex", ((value, element, regexp) ->
  re = new RegExp(regexp)
  @optional(element) or re.test(value)
), "Please check your input."

$.validator.addMethod "integer", ((value, element, param) ->
  (value is parseInt(value, 10))
), "Please enter a integer value!"

$.validator.addMethod "absence", ((value, element, param) ->
  !blank(value)
), "Please leave this field blank!"

$.validator.addMethod "greater_than_or_equal_to", ((value, element, param) ->
  (blank(value) or parseFloat(value) >= param)
), "Please enter a value grater than or equal to"

$.validator.addMethod "greater_than", ((value, element, param) ->
  blank(value) or parseFloat(value) > param
), "Please enter a value grater than "

$.validator.addMethod "equal_to", ((value, element, param) ->
  blank(value) or parseFloat(value) == parseFloat(param)
), "Please enter a value equal to "

$.validator.addMethod "less_than", ((value, element, param) ->
  blank(value) or parseFloat(value) < parseFloat(param)
), "Please enter a value less than "

$.validator.addMethod "less_than_or_equal_to", ((value, element, param) ->
  parseFloat(value) <= parseFloat(param)
), "Please enter a value less than or equal to "

$.validator.addMethod "odd", ((value, element, param) ->
  blank(value) or parseInt(value)%2 > 0
), "Please enter odd value."

$.validator.addMethod "even", ((value, element, param) ->
  blank(value) or parseInt(value)%2 == 0
), "Please enter even value."

$.validator.addMethod "inclusion", ((value, element, param) ->
  blank(value) or $.inArray(value, param)>-1
), "is invalid."

$.validator.addMethod "exclusion", ((value, element, param) ->
  blank(value) or !($.inArray(value, param)>-1)
), "is invalid."

$.validator.addMethod "length_is", ((value, element, param) ->
  blank(value) or value.length==param
), "is invalid."

$.validator.addMethod "length_minimum", ((value, element, param) ->
  blank(value) or value.length>=param
), "is invalid."

$.validator.addMethod "length_maximum", ((value, element, param) ->
  blank(value) or value.length<=param
), "is invalid."