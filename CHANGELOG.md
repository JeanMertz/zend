## 0.1.2 (September 7, 2013)

Bugfixes:

  - correctly unset credentials on authentication retry

## 0.1.1 (September 7, 2013)

Bugfixes:

  - show correct help message for `zend show`
  - remove stored credentials on failed authentication

Features:

  - use Zendesk user passwords instead of API token which are only
    available to admins
  - allow 3 authentication retries before exiting command

## 0.1.0 (September 7, 2013)

Features:

  - `zend login` to log in to your Zendesk account
  - `zend logout` to remove local Zendesk credentials
  - `zend show <ticket id>` to show basic ticket information
  - set `ZEND_ACCOUNT` environment variable to skip account detail
    requests for each command
