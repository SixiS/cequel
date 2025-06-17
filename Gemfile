source 'https://rubygems.org'

gemspec

group :debug do
  gem 'byebug'
  gem 'pry'
end

group :development do
  gem 'rubocop', require: nil
end

group :development, :test do
  gem 'debug'
end

gem 'racc'
gem 'psych'
gem 'sorted_set'

gem "ione", github: "hornet-network/ione", branch: "main"
gem "cassandra-driver", github: "hornet-network/ruby-driver", branch: "main"
