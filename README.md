# RéSo

Apporter l’ensemble des aides publiques aux entreprises qui en ont besoin. [reso.beta.gouv.fr](https://reso.beta.gouv.fr/)

Créé dans le contexte de [l’incubateur des startups d’état](https://beta.gouv.fr/).

From now on, we’re gonna switch in English.

## Getting started

1. Clone the repository.

        $ git clone git@github.com:betagouv/reso.git
        $ cd reso

2. Install Ruby using **rvm**. See `Gemfile` file to know which Ruby version is needed.

        $ brew install rvm
        $ rvm install x.x.x

3. Install PostgreSQL and create a user if you don’t have any.

        $ brew install postgres

    Create a PostgreSQL user (replace `my_username` and `my_password`).

        $ psql -c "CREATE USER my_username WITH PASSWORD 'my_password';"

    Or:

        $ postgres createuser my_username

4. Create `config/database.yml` file from `config/database.yml.example`. Fill development and test sections in the latter with your PostgreSQL username and password.

        $ cp config/database.example.yml config/database.yml

5. Install project dependencies (gems) with bundler.

        $ gem install bundler
        $ bundle

6. Install yarn and use `yarn` command to install JS library dependencies (such as Vue.js).

        $ brew install yarn
        $ yarn

    The project uses Vue.js with Rails 5 [Webpacker](https://github.com/rails/webpacker).

7. Execute database configurations for development and test environments.

        $ rake db:create db:migrate
        $ rake db:create db:migrate RAILS_ENV=test

8. Create `.env` file from `.env.example`, and ask the team to fill it in.

        $ cp .env.example .env

9. Configure Git to prepend commit messages with branch name.

        $ curl https://gist.githubusercontent.com/jvenezia/57673140506ae9e330c2/raw/bff6973325b159254a3ba13c5cb9ac8fda8e382b/prepare-commit-msg.sh -o .git/hooks/prepare-commit-msg
        $ chmod +x .git/hooks/prepare-commit-msg

10. You can now start a server.

        $ gem install foreman
        $ foreman start --procfile=Procfile.dev

    And yay! Reso is now [running locally](http://localhost:3000)!

## Tests

You can run all application tests with `./meta_rake` command. It launches following tests:

- `rake` : Rspec tests
- `npm test` : Jasmine front-end tests
- `rubocop` : Ruby/Rails/Rspec code style
- `npm run linter` : JS code style
- `haml-lint app/views/` : Haml template code style
- `i18n-tasks unused && i18n-tasks missing` : Rails I18n usage

You can run these tests individually.

You may need to install [Node.js](https://nodejs.org/en/download/) for `npm` command.

## Development data

You can import data in your local development database from remote staging database. See the [official documentation](https://doc.scalingo.com/platform/databases/access), Make sure [Scalingo CLI](http://doc.scalingo.com/app/command-line-tool.html) is installed.

1. Dump data from staging or production environments:
````
scalingo -a reso-staging db-tunnel SCALINGO_POSTGRESQL_URL
# In another terminal
scalingo -a reso-staging env # gives you the database password
pg_dump --no-owner --no-acl reso_stagin_5827 > tmp/export.pgsql  -h localhost -p 10000 -U reso_stagin_5827 -o
````

````
scalingo -a reso-production db-tunnel SCALINGO_POSTGRESQL_URL
# In another terminal
scalingo -a reso-production env # gives you the database password
pg_dump --no-owner --no-acl e_conseils_2947 > tmp/export.pgsql  -h localhost -p 10000 -U e_conseils_2947 -o
````

2. Import the dump in the local database: 
````
rake db:drop db:create
psql reso-development -f tmp/export.pgsql -U postgres
rake db:migrate # If your local app has pending migrations
rake db:environment:set RAILS_ENV=development # If you imported data from the production environment
````

## Emails

Development and staging emails are sent on [Mailtrap](https://mailtrap.io/) in order to test email notifications without sending them to the real users. Ask the team for credentials.

## Deployment

Reso is deployed on [Scalingo](http://doc.scalingo.com/languages/ruby/getting-started-with-rails/), with two distinct environment, ``reso-staging`` and `reso-production.

* `reso-staging` is served at https://reso-staging.scalingo.io.
* ``reso-production`` is the actual https://reso.beta.gouv.fr

GitHub->Scalingo hooks are setup for auto-deployment:
* The `master` branch is automatically deployed to the `reso-staging` env.
* The `production` branch is automatically deployed to the `reso-staging` env.  

Additionally, a `postdeploy` hook [is setup in the Procfile](https://doc.scalingo.com/platform/app/postdeploy-hook#applying-migrations) so that Rails migrations are run automatically.  

In case of emergency, you can always run rails migrations manually using the `scalingo` command line tool.
    
    $ scalingo -a reso-staging run rails db:migrate
    $ scalingo -a reso-production run rails db:migrate 

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our git and coding conventions, and the process for submitting pull requests to us.
