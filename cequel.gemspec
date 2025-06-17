require File.expand_path('../lib/cequel/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'cequel'
  s.version = Cequel::VERSION
  s.authors = [
    'Mat Brown', 'Aubrey Holland', 'Keenan Brock', 'Insoo Buzz Jung',
    'Louis Simoneau', 'Peter Williams', 'Kenneth Hoffman', 'Antti Tapio',
    'Ilya Bazylchuk', 'Dan Cardamore', 'Kei Kusakari', 'Oleh Novosad',
    'John Smart', 'Angelo Lakra', 'Olivier Lance', 'Tomohiro Nishimura',
    'Masaki Takahashi', 'G Gordon Worley III', 'Clark Bremer', 'Tamara Temple',
    'Long On', 'Lucas Mundim', 'William Flanagan', 'Inaki Lanusse'
  ]
  s.homepage = "https://github.com/cequel/cequel"
  s.email = 'mat.a.brown@gmail.com'
  s.license = 'MIT'
  s.summary = 'Full-featured, ActiveModel-compliant ORM for Cassandra using CQL3'
  s.description = <<DESC
Cequel is an ActiveRecord-like domain model layer for Cassandra that exposes
the robust data modeling capabilities of CQL3, including parent-child
relationships via compound primary keys and in-memory atomic manipulation of
collection columns.
DESC

  s.files = Dir['lib/**/*.rb', 'templates/**/*', 'spec/**/*.rb', '[A-Z]*']
  s.test_files = Dir['spec/examples/**/*.rb']
  s.required_ruby_version = '>= 3.0'

  s.add_runtime_dependency 'activemodel', '>= 7.0'
  s.add_runtime_dependency 'logger'
  s.add_runtime_dependency 'cassandra-driver'
  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'wwtd'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-its'
  s.add_development_dependency 'rspec-retry'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'parallel'

  s.requirements << 'Cassandra >= 2.0.0'
end
