set :vagrant_port, `vagrant ssh-config | grep Port`.split(' ')[1].chomp

server 'localhost',
  roles: %w{web},
  ssh_options: {
    auth_methods: %w(publickey),
    user: 'vagrant',
    port: fetch(:vagrant_port),
    keys: [
      '~/.vagrant.d/insecure_private_key',
      `find . -name private_key`.chomp
    ]
  }
