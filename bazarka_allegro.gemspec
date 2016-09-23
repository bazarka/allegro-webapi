# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
#$:.push File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "bazarka_allegro"
  spec.version       = "0.0.3"
  spec.authors       = ["Jaroslaw Wozniak"]
  spec.email         = ["jarwoz@gmail.com"]
  spec.description   = %q{Api wrapper for allegro webapi written in ruby. Make it supereasy to interact with allegro api.}
  spec.summary       = %q{API WRAPPER for allegro web api}
  spec.homepage      = "http://www.bazarka.pl"
  spec.license       = "MIT"

  spec.rubyforge_project = 'bazarka_allegro'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]


  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency 'savon', '~> 2.10.0'
  spec.add_development_dependency 'webmock'
  #spec.add_development_dependency 'minitest', '5.0.8'
  #spec.add_development_dependency 'vcr', '2.6.0'
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'm'

  spec.add_development_dependency "rspec"

end
