Capistrano deploy demo - PHP App
---------------------------------

This is a simple PHP app for demonstrating Capistrano deployment. Provides a
vagrant box to deploy to, and a few exercises. See [this box](#this-box).


## About Capistrano

- [Documentation](http://capistranorb.com/)
- [Workflow](http://capistranorb.com/documentation/getting-started/flow/)
- [Variables and methods](http://www.freelancingdigest.com/articles/capistrano-variables/)
- [Folder structure](http://capistranorb.com/documentation/getting-started/structure/)

Capistrano is a deployment tool build on top of a ruby ssh wrapper and rake (ruby task runner).

Given the target folder is: `set :deploy_to, '/var/www/my_app_name'`, the
following would be the structure of the folders on the target server(s):

```
├── current -> /var/www/my_app_name/releases/20150120114500/ # this is a symlink to a release
├── releases            # here are the releases. Each release is an attempt of deploy
│   ├── 20150080072500
│   ├── 20150090083000
│   ├── 20150100093500
│   ├── 20150110104000
│   └── 20150120114500
├── repo                # git repo
├── revisions.log       # log with user who deployed/rolled back, release, and time
└── shared
    └── <linked_files and linked_dirs>
```


### Config files (on this customized folder structure)

```
Gemfile               # ruby dependencies, such as rake and capistrano
Capfile               # file that capistrano will read in order to deploy
deploy                # custom folder for deployment config (by default it is config)
├── config.rb         # general config
├── environments      # configs per environment, such as servers to deploy to
│   ├── production.rb
│   └── staging.rb
├── README.md
└── tasks             # tasks separated by namespace. They do not have to be there, but it is more organized
    ├── foo.rake
    └── bar.rake
```

### This box

#### The VM

- It is a ubuntu box running nginx and PHP FPM serving [/var/www/apps/app_demo/current/public](https://github.com/mjacobus/capistrano-demo/blob/master/vagrant/templates/etc/nginx/sites-available/vagrant#L36)

#### How Capistrano was set

- Created [Gemfile](https://github.com/mjacobus/capistrano-demo/blob/7ca39d45a6be778768b798348d4d05ffef5baca0/Gemfile) and installed 
Capistrano - [see diff](https://github.com/mjacobus/capistrano-demo/commit/7ca39d45a6be778768b798348d4d05ffef5baca0) by running:

```
bundle install            # install dependencies
bundle exec cap install   # creates files for initial capistrano setup
```

- Changed its default config - [see diff](https://github.com/mjacobus/capistrano-demo/commit/aba38c20179f6ac30d3f9c989554b14ecd1653fd)
- Enabled plugins - [see diff](https://github.com/mjacobus/capistrano-demo/commit/85a7a5f45a91a851ad017ce95d1124d41fb49ab1)
- Added vagrant environment and repo source - [see diff](https://github.com/mjacobus/capistrano-demo/commit/2b882592d4f1b7e025220945f1548e9620d09e6f)

### Exercises:

Before you start the exercises, make sure you can get your environment up and running:

```
vagrant up                      # starts target server
bundle install                  # install dependencies
bundle exec cap vagrant deploy  # install dependencies
```

The above means you need vagrant and blundler, and of course, ruby.

Then, navigate to [http://localhost:9000/](http://localhost:9000/) and make
sure you can see a web app with some pictures and view count. It was made slow
on [purpose](https://github.com/mjacobus/capistrano-demo/blob/master/app/asset_fallback.php#L33)
in a way that you can fix by only going throw the exercises.


1. Change deployment so the assets folder is the same after every single deployment
  - Make sure assets folder is created on deploy
  - Add it to the symlink folders

  ```
  bundle exec cap vagant assets:create_folder
  ```

  - for resolution see branch [ex-01](https://github.com/mjacobus/capistrano-demo/commit/276689f890b9771d970ddef90cbc13a2601fe68f)

2. Create a task to list assets folders

  ```
  bundle exec cap vagant assets:list
  ```

  - for resolution see branch [ex-02](https://github.com/mjacobus/capistrano-demo/commit/817c8aef0b1f5723ec401b33fcbd76e334f85b61)

3. Make page count persist over deploys

  - for resolution see branch [ex-03](https://github.com/mjacobus/capistrano-demo/commit/afbe853426697f7ae055d69eccae71f601ec91ab)


4. Create a task to clear page count

  ```
  bundle exec cap vagant page_views:clear
  ```

  - for resolution see branch [ex-04](https://github.com/mjacobus/capistrano-demo/commit/79fa094f6a895327cca240b0a937f3b8866bb6ce)

