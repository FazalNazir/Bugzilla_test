# LND

HRMS API provides useful endpoints for [HRMS-FrontEnd](https://github.com/usmanasif1/hrms-frontend)

---

### Contents

- [Technology stack](#technology-stack)
- [Installation](#installation)

## Technology stack

- Ruby 3.0.0 (bundler v 2)
- Ruby on Rails 7.0.3
- PostgreSQL 14
- Application Server: Puma

## Installation

### Requirements

Before you get started, the following needs to be installed:

- **Ruby**. Version 3.0.0 is currently used and we don't guarantee everything works with other versions. If you need multiple versions of Ruby, [RVM](https://rvm.io//) or [rbenv](https://github.com/rbenv/rbenv) is recommended.
- **Redis**.
- [**RubyGems**](http://rubygems.org/)
- **Bundler**: `gem install bundler`
- [**Git**](http://help.github.com/git-installation-redirect)
- **A database**. Only PostgreSQL 14 has been tested, so we give no guarantees that other databases (e.g. mySQL) work. You can install PostgreSQL by:

  sudo apt-get install postgresql-14

### Setting up the development environment

1.  Get the code. Clone this git repository and check out the latest release:

    ```bash
    git clone https://github.com/DIncProd/LnD-System.git
    cd LnD-System
    ```

2.  Install the required gems and npm dependencies by running the following command in the project root directory:

    ```bash
    bundle install
    ```

    dependencies installation:

    ```bash
    yarn install
    ```

3.  Add necessary credentials:

    ```bash
    development:
      postgres:
        username:
        password:
      GOOGLE_CLIENT_ID:
      GOOGLE_CLIENT_SECRET:
    time_zone:
    gmail:
      username:
      password:
    ```

4.  Create, populate database and run seed :

```
rails db:create db:migrate db:seed
```

5.  Run server:

    `bin/dev`

    ```
    whenever //this will show you scheduled jobs in cron syntax, review the jobs carefully
    whenever --update-crontab //updates cron-tab for UNIX based systems
    ```

### Set up git hooks

Install [overcommit](https://github.com/brigade/overcommit) git hook manager

```
  overcommit --install
```

Sign configuration file so overcommit is able to read it

```
overcommit --sign
```

Now the configured hooks in `.overcommit.yml` will run everytime you run `git commit`, being `RuboCop` the most important one.

If, for any reason, you need to commit changes that fail to pass the rubocop check, you can skip it by running

```
SKIP=RuboCop git commit
```
