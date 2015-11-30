# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nicolive/version'

Gem::Specification.new do |spec|
  spec.name          = "nicolive"
  spec.version       = Nicolive::VERSION
  spec.authors       = ["maruware"]
  spec.email         = ["me@maruware.com"]

  spec.summary       = %q{Accessor for a Nicovideo live.}
  spec.description   = %q{Accessor for a Nicovideo live.}
  spec.homepage      = "https://github.com/maruware/nicolive"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.test_files    = spec.files.grep(%r{^(test)/})
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'mechanize', '~> 2.7'
  spec.add_dependency 'eventmachine', '>= 1.0.3'
  spec.add_dependency 'addressable', '>= 2.3.8'

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'minitest', '~> 5.0.0'
end
