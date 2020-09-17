## 1.0.0

- **BREAKING**: You are now required to use the tracking API key to authenticate. Visit https://connect.getvero.com/settings/project/tracking-api-keys to manage your tracking API keys. The original way of using API key and secret is no longer supported in this version.

- **BREAKING**: Removed "development_mode" flag (previously deprecated in 0.8.0)

- **BREAKING**: Raised minimum Ruby version requirement to 2.7

- Added Zeitwerk for improved code autoloading

- Added `http_timeout` configuration option. By default it is set to 60 (seconds).

## 0.9.0

- **Added support for Sidekiq**. You can now use Sidekiq to deliver API requests to Vero. To do so, just specify `config.async = :sidekiq` in your config.rb file.

## 0.8.0

- **"development_mode" flag has been deprecated.** It is recommended to use a multiple projects (with different API credentials). Please contact support@getvero.com for assistance in upgrading your account.

## 0.7.0

- **girl_friday has been replaced by sucker_punch**. The most significant effect of this change is that Ruby 1.8.7 will no longer be supported.

## 0.6.0

- **All APIs using the `trackable` interface will now pass up an `:id`** (if it has been made available). In the past the gem would assume that the user's id would always be equal to their email address, but now the gem properly implements the Vero API.

- **`update_user!` method no longer takes an optional new email address as a parameter**. It is recommended that the email be made a trackable field.
