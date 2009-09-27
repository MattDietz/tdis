# Note that this whole menagerie is very Ubuntu specific

#Would love to have:
#
#CSS and JS minifying
    
mongrel_cluster_config = 
  '---\n'\
  'cwd: /var/www/current\n'\
  'log_file: /var/www/current/log/mongrel.log\n'\
  'port: "8000"\n'\
  'environment: production\n'\
  'pid_file: tmp/pids/mongrel.pid\n'\
  'servers: 2\n'

set :application, "thedayisshot"
set :destination, "www.thedayisshot.com"
set :port, 22
set :repository, "ssh://matt@www.buriedincode.com/home/matt/code/ruby/rofldubbs"
# You can also use the following lines to just copy from your local machine
# set :repository, 'file:///mylocalrepopath'
# set :deploy_via, :copy

# The following deploys via rsync and keeps a cache so we're only copying over
# the files that have changed. 
# set :deploy_via, :rsync_with_remote_cache
# set :rsync_options, '-az --delete --exclude=.git --delete-excluded'
set :deploy_via, :remote_cache

set :scm, :git
set :scm_username, "matt"
set :deploy_to, "/var/www/"
set :user, "control"

set :runner, 'control'
role :app

server "#{runner}@#{destination}", :app, :primary => true

task :process_list do
  run "ps -eaf"
end

task :before_update_code do
  stop_mongrels
end

task :after_update_code do
  start_mongrels
end

task :create_mongrel_config do
  sudo "mkdir /etc/mongrel_cluster; true"
  sudo "touch /etc/mongrel_cluster/#{application}.yml"
  sudo "chown #{runner}:#{runner} /etc/mongrel_cluster/#{application}.yml"
  sudo "echo -n -e '#{mongrel_cluster_config}' > /etc/mongrel_cluster/#{application}.yml"
  sudo "chown root:root /etc/mongrel_cluster/#{application}.yml"
end

task :start_mongrels do
  sudo "mongrel_cluster_ctl start -c /etc/mongrel_cluster/"
end

task :stop_nginx do
  sudo "/etc/init.d/nginx stop"
end

task :start_nginx do
  sudo "/etc/init.d/nginx start"
end

task :stop_mongrels do
  sudo "mongrel_cluster_ctl stop -c /etc/mongrel_cluster"
end

task :disable_remote_root do
  #I'm sure there's a better way to do this
  run "cd /home/#{runner}/; sudo cat /etc/ssh/sshd_config | grep -v 'PermitRootLogin' > ./tmp ; echo 'PermitRootLogin no' >> ./tmp"
  run "sudo rm /etc/ssh/sshd_config; sudo cp ./tmp /etc/ssh/sshd_config"
  run "sudo chown root:root /etc/ssh/sshd_config"
  run "sudo chmod 644 /etc/ssh/sshd_config"
  sudo "/etc/init.d/ssh restart"
end

task :restart_mongrels do
  sudo "mongrel_cluster_ctl restart -c /etc/mongrel_cluster"
end

# The packaged ubuntu gems version never finishes installing anything on a
# 256 slice. Set with -S gem_url=http://... on the command line
task :copy_and_install_gems_package do
  gem_url = ' http://rubyforge.org/frs/download.php/45905/rubygems-1.3.1.tgz' unless exists?(:gem_url)
  tar_path = gem_url.split('/')[-1]
  path = "/home/#{runner}"
  gem_folder = tar_path.split('.tgz')
  run "mkdir #{path}; true"
  run "cd /home#{runner}; wget #{gem_url}"
  run "tar xzf #{path}/#{tar_path}"
  sudo "ruby #{path}/#{gem_folder}/setup.rb"
end

task :copy_nginx_config do
  run "scp -P#{port} nginx.conf #{runner}@#{destination}:~/"
  run "sudo mv ~/nginx.con /etc/nginx"
  run "scp -P#{port} #{application} #{runner}@#{destination}:~/" 
  sudo "mv ~/#{application} /etc/nginx/sites-available/"
  sudo "rm /etc/nginx/sites-enabled/default"
  sudo "chown root:root /etc/nginx/sites-available/#{application}"
  sudo "ln -s /etc/nginx/sites-available/#{application} /etc/nginx/sites-enabled/#{application} "
end

task :install_ubuntu_packages do
  sudo "apt-get install git-core"
  sudo "apt-get install ruby"
  sudo "apt-get install mysql"
  sudo "apt-get install ruby1.8-dev"
  sudo "apt-get install gcc"
  sudo "apt-get install build-essential"
  sudo "apt-get install make"
  copy_and_install_gems_package
  sudo "apt-get install libmysql-ruby1.8"
  sudo "apt-get install nginx"
  copy_nginx_config
end

task :set_iptables_rules do

end

task :install_ruby_gems do
  #sudo "gem update --system"
  sudo "gem install rails -v=2.2.2"
  sudo "gem install ruby-recaptcha"
  sudo "gem install hpricot"
  sudo "gem install mongrel_cluster"
end

task :setup_server do
  install_ubuntu_packages
  install_ruby_gems
  create_mongrel_config
  set_iptables_rules
end
