namespace :styles do
  desc 'style shit'
  task :default do
    system "sass -v"
  end

  task :watch do
    desc 'Watch styles and compile new changes'
    system "sass --watch assets/scss/:styles/"
  end
end
