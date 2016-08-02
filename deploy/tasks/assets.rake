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

  desc "lists assets"
  task :list do
    on roles(:web) do
      within shared_path do
        info "listing #{shared_path} (won't be listed if airbrush is enabled)"
        execute :ls, '-la', shared_path
      end
    end
  end
end
