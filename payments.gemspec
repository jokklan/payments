# Encoding: UTF-8

require File.expand_path('../lib/payments/version', __FILE__)

Gem::Specification.new do |gem|
  gem.platform          = Gem::Platform::RUBY
  gem.authors           = ["Johan Frølich"]
  gem.email             = ["johanfrolich@gmail.com"]
  gem.name              = 'payments'
  gem.version           = Payments::Version.to_s
  gem.description       = 'Ruby on Rails Payments extension'
  gem.date              = '2012-09-27'
  gem.summary           = 'Payments extension'
  gem.require_paths     = %w(lib)
  gem.files             = Dir["{app,config,db,lib}/**/*"] + ["readme.md"]

  # Runtime dependencies
  gem.add_dependency             'activemerchant',      '~> 1.28.0'
  gem.add_dependency             'state_machine',       '~> 1.1.2'
  gem.add_dependency             'slim',                '~> 1.3.2'
end
