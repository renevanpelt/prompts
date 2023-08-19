Gem::Specification.new do |s|
  s.name        = 'prompts'
  s.version     = '0.1.0'
  s.date        = '2023-08-20'
  s.summary     = 'Prompts Ruby Gem'
  s.description = 'Prompts' # Replace with a suitable description.
  s.authors     = ['🍐']
  s.email       = 'you@example.com'
  s.files       = Dir['lib/**/*.rb']
  s.homepage    =
    'https://github.com/your_github_username/prompts'
  s.license       = 'MIT' # Choose your license
  s.required_ruby_version = '>= 2.6.0'
  s.add_dependency 'sorbet-runtime'
  s.add_dependency 'ruby-openai'
  s.add_dependency 'tapioca'
  s.add_dependency 'rspec'
  s.add_dependency 'sorbet'
end