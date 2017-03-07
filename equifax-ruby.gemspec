# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'equifax/version'

Gem::Specification.new do |spec|
  spec.name          = "equifax-ruby"
  spec.version       = Equifax::VERSION
  spec.authors       = ["James Dullaghan", "Rutul Dave", "Puneet Sutar", "Bret Doucette"]
  spec.email         = ["james@himaxwell.com", "rutul@himaxwell.com", "bret@himaxwell.com"]

  spec.summary       = %q{Wrapper for equifax XML API}
  spec.description   = %q{This wrapper creates commonly used requests for the equifax API}
  spec.homepage      = "https://github.com/himaxwell/equifax-ruby"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"

  spec.add_dependency "ox"
  spec.add_dependency "json"
  spec.add_dependency "lumberjack"
  spec.add_dependency "activesupport"
end
