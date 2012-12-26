require 'rspec/core/rake_task'

namespace :spec do
  desc 'Run all specs'
  RSpec::Core::RakeTask.new('all')
end

task :spec => 'spec:all'
task :default => :spec
Dir["tasks/*.rake"].sort.each { |ext| load ext }
