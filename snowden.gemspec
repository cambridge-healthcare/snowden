# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'snowden/version'

Gem::Specification.new do |spec|
  spec.name          = "snowden"
  spec.version       = Snowden::VERSION
  spec.authors       = ["Sam Phippen", "Stephen Best"]
  spec.email         = ["samphippen@googlemail.com", "stephen@howareyou.com"]
  spec.description   = %q{Fuzzy encrypted indexes in ruby}
  spec.summary       = %q{Fuzzy encrypted indexes in ruby}
  spec.homepage      = "http://github.com/cambridge-healthcare/snowden"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
