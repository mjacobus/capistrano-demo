namespace :assets do
  desc "make sure the assets folder exists"
  task :create_folder do
    on roles(:web) do
      within shared_path do
        info "creating assets tolder"
        execute :mkdir, '-p', 'public/assets'
      end
    end
  end
end
