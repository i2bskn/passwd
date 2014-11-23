## 0.2.0

Remake the this library.

#### Upgrade

1. Run the following commands.

```
$ bundle update passwd
$ bundle exec rails gneratate passwd:config
```

2. Migrate your passwd settings to `config/initializers/passwd.rb`.
3. Updates your code!

#### Changes

- Add extention to ActiveController.
    - Add `current_user`, `signin!` and `signout!` to ActionController.
    - Add `require_signin` method for `before_action`.
- Include the `Passwd::ActiveRecord` was no longer needed.
- Rename method `define_column` to `with_authenticate` in your User model.
- Rename method `Passwd.create` to `Passwd.random`.
- Rename method `Passwd.hashing` to `Passwd.digest`.
- Add `passwd` method User class. Create Passwd::Password object from target user attributes.
- Split object password and salt.

## 0.1.5

#### Changes

- Can be specified algorithm of hashing
- Change default hashing algorithm to SHA512 from SHA1

