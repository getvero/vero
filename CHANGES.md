## HEAD

- **"development_mode" flag has been deprecated.** It is recommended to use a multiple projects (with different API credentials). Please contact support@getvero.com for assistance in upgrading your account.

## 0.6.0

- **All APIs using the `trackable` interface will now pass up an `:id`** (if
it has been made available). In the past the gem would assume that the user's id
would always be equal to their email address, but now the gem properly implements
the Vero API.

- **`update_user!` method no longer takes an optional new email address as a
parameter**. It is recommended that the email be made a trackable field.
