default_run_options[:pty] = true

set :application, "leads"
set :user, "primary0"
set :domain, "core.primary0.com"
set :home_path, "home"

# set :repository, "#{user}@#{domain}:/#{home_path}/#{user}/#{application}_repository"
set :repository, "."
set :deploy_to, "/#{home_path}/#{user}/#{application}_live"

set :deploy_via, :copy
set :copy_strategy, :checkout
set :copy_cache, true
set :copy_exclude, [".git/*", ".git", "config/deploy.rb", "Capfile", ".gitignore", "test/*", "test", "*.tmproj"]
set :copy_compression, :gzip

set :branch, "master"
set :git_shallow_clone, 1

set :scm, "git"
set :scm_verbose, true
set :use_sudo, false

role :web, domain
role :app, domain
role :db, domain, :primary => true

namespace :db do
  desc "Create database yaml in shared path"
  task :default do
    
    db_name = Capistrano::CLI.ui.ask("Database Name: ")
    db_username = Capistrano::CLI.ui.ask("Database Username: ")
    db_password = Capistrano::CLI.password_prompt("Database Password: ")
        
    db_config = ERB.new <<-EOF
    base: &base
      adapter: mysql
      host: localhost
      username: #{db_username}
      password: #{db_password}
      database: #{db_name}  

    development:
      <<: *base

    production:
      <<: *base
    EOF

    run "mkdir -p #{shared_path}/config" 
    put db_config.result, "#{shared_path}/config/database.yml" 
  end

  desc "Make symlink for database yaml" 
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
  end
end

before "deploy:setup", :db
after "deploy:update_code", "db:symlink"

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{deploy_to}/current/tmp/restart.txt"
  end
  
  task :restart, :roles => :app do
    run "touch #{deploy_to}/current/tmp/restart.txt"
  end
end
