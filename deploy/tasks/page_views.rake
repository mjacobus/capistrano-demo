namespace :page_views do
  desc "clears page views"
  task :clear do
    on roles(:web) do
      within shared_path do
        info "clearing page views"
        execute :rm, '-rf', 'log/views/*'
      end
    end
  end
end
