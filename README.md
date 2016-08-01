Capistrano deploy demo - PHP App
---------------------------------

- Installed capistrano - [see diff](https://github.com/mjacobus/capistrano-demo/commit/7ca39d45a6be778768b798348d4d05ffef5baca0)
  - Created [Gemfile](https://github.com/mjacobus/capistrano-demo/blob/7ca39d45a6be778768b798348d4d05ffef5baca0/Gemfile) and then

```
bundle install
bundle exec cap install
```

- Changed its default config - [see diff](https://github.com/mjacobus/capistrano-demo/commit/aba38c20179f6ac30d3f9c989554b14ecd1653fd)
- Enabled plugins - [see diff](https://github.com/mjacobus/capistrano-demo/commit/85a7a5f45a91a851ad017ce95d1124d41fb49ab1)
- Added vagrant environment and repo source - [see diff](https://github.com/mjacobus/capistrano-demo/commit/2b882592d4f1b7e025220945f1548e9620d09e6f)

### Exercises:


1. Change deployment so the assets folder is the same after every single deployment
  - Make sure assets folder is created on deploy
  - Add it to the symlink folders

  ```
    cap vagant assets:create_folder
  ```

2. Create a task to list assets folders

  ```
  cap vagant assets:list
  ```

3. Make page count persist over deploys


4. Create a task to clear page count

  ```
  cap vagant page_views:clear
  ```
