# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'blinken_window/version'

Gem::Specification.new do |spec|
  spec.name          = "blinken_window"
  spec.version       = BlinkenWindow::VERSION
  spec.authors       = ["Akhil Stanislavose"]
  spec.email         = ["akhil.stanislavose@gmail.com"]
  spec.description   = %q{Ruby library to control the blinken lights inspired blinken window}
  spec.summary       = %q{Build awesome blinken applications!}
  spec.homepage      = "https://github.com/akhilstanislavose/blinken-window"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
