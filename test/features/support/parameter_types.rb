# frozen_string_literal: true

ParameterType(
  name: 'patterns',
  regexp: %r{([^\s]*|'[^']*'|/[^/]*/)(,\s*([^\s]*|'[^']*'|/[^/]*/))*},
  type: Array,
  transformer: lambda do |*patterns|
                 patterns \
                   .map(&:strip) \
                   .map do |s|
                     s = if %r{^/(.*)/$} =~ s
                           Regexp.last_match(1)
                         elsif %r{^'(.*)'$} =~ s
                           "^#{Regexp.escape(Regexp.last_match(1))}$"
                         else
                           "^#{Regexp.escape(s)}$"
                         end
                     Regexp.compile(s)
                   end
               end
)

ParameterType(
  name: 'env_glob',
  regexp: /[A-Z_*]+/,
  type: Regexp,
  transformer: lambda do |glob|
    /^#{glob.gsub('*', '[A-Z_]*')}=/
  end
)
