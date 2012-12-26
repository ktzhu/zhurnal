namespace :styles do
  desc 'Watch styles and compile new changes'

  task :default do
    system "sass -v"
  end

  task :watch do
    system "sass --watch assets/scss/:styles/"
  end
end
