namespace :deploy do
  task :create_robots do
    on roles(:web) do
      within(release_path) do
        execute :echo, 'foo', '>', 'public/robots.txt'
      end
    end
  end
end
