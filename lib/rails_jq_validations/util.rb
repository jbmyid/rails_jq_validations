module Util
  def self.json_regexp(regexp)
    str = regexp.inspect.
          sub('\\A' , '^').
          sub('\\Z' , '$').
          sub('\\z' , '$').
          sub(/^\// , '').
          sub(/\/[a-z]*$/ , '').
          gsub(/\(\?#.+\)/ , '').
          gsub(/\(\?-\w+:/ , '(').
          gsub(/\s/ , '')
    Regexp.new(str).source
  end
end