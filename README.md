# Nexmo Developer

This repository is the code and content for <https://developer.nexmo.com> including the Nexmo documentation, API reference, SDKs, Tools & Community content.

## Contributions

We welcome contributions from everyone! Look at the [Contributor Guidelines](CONTRIBUTING.md) for more information.

## Testing

We use [rspec](http://rspec.info/) to test Nexmo Developer.

To run all tests:

```bash
bundle exec rspec
```

To generate code coverage, set the `COVERAGE` environment variable when running the tests.

```bash
COVERAGE=1 bundle exec rspec
```

This will create a folder named `coverage`. Open `index.hml` in this folder to view coverage statistics

## Running locally

The project can be run on your laptop, either directly or using Docker. These instructions have been tested for mac.

### Setup for running directly on your laptop

Before you start, you will need to make sure that you have:

- Ruby 2.5.0 + bundler
- PostgreSQL
- [Yarn](https://yarnpkg.com/en/docs/install)

To set up the project, clone this project and configure your settings:

```
$ git clone git@github.com:Nexmo/nexmo-developer.git
$ cd nexmo-developer
$ cp .env.example .env
```

Edit the `.env` file as appropriate for your platform.  Then, run the following:

```
$ bundle install
$ rake db:create
$ rake db:migrate
$ rake db:seed
$ ./bin/yarn install
$ rails s
```

You should now be able to see the site on http://localhost:3000/

### Setting up with Docker

If you don't want to install Ruby & PostgreSQL then you can use docker to sandbox Nexmo Developer into its own containers. After you [Install Docker](https://docs.docker.com/engine/installation/) run the following:

```
$ git clone git@github.com:Nexmo/nexmo-developer.git
$ cd nexmo-developer
$ cp .env.example .env
```

Edit the `.env` file as appropriate for your platform.  Then, start the web server with this command:

```
$ docker-compose up
```

At this point, open your browser to http://localhost:3000/ ... and wait (it takes about 30 seconds for the first load).

To stop the server cleanly run:

```
$ docker-compose down
```

## Admin dashboard

You can access the admin dashboard by visiting `/admin`. If you've populated data via `rake db:seed` you will have an admin user with the username of `admin@nexmo.com` and password of `development`.

The following is an example if you are running Nexmo Developer within a Docker container:

```sh
docker exec -it <container_id> rake db:seed
```

New admin users can be created by visiting `/admin/users` or by accessing the rails console and creating a new User like so:

```ruby
User.create!(email: 'example@example.com', password: 'password', admin: true)
```

## Working with submodules

Some of the contents of NDP are brought in via git submodules, such as the Open API Specification (OAS) documents. A submodule is a separate repository used within the main repository (in this case NDP) as a dependency. The main repository holds information about the location of the remote repository and **which commit to reference**. So to make a change within a submodule, you need to commit to the submodule and the main repository and crucially remember to push both sets of changes to GitHub.

Here are some tips for working with submodules:

### When cloning the repo or starting to work with submodules

```
git submodule init
git submodule update
```

### When pulling in changes to a branch e.g. updating master

```
git pull
git submodule update
```

### When making changes inside the submodule within NDP

Make sure you are _inside_ the directory that is a submodule.

- make your changes
- commit your changes
- _push your changes from here_ (this is the bit that normally trips us up)
- open a pull request on the submodule's repository - we can't open the PR on the main repo until this is merged

You are not done, keep reading! A second pull request is needed to update the main repo, including any other changes to that repo _and_ an update to the submodule pointing to the new (merged) commit to use.

- open your PR for this change including any changes to the main project (so we don't lose it) but label it "don't merge" and add the URL of the submodule PR we're waiting for
- once the submodule has the change you need on its master branch, change into the subdirectory and `git pull`
- change directory back up to the root of the project
- commit the submodules changes
- _push these changes too_
- Now we can review your PR


### Bringing submodule changes into NDP

If you made changes on the repo outside of NDP, then you will need to come and make a commit on NDP to update which commit in the submodule the NDP repository is pointing to.

Make a branch, change into the submodule directory and `git pull` or do whatever you need to do to get `HEAD` pointing to the correct commit. In the top level of the project, add the change to the submodules file and commit and push. Then open the pull request as you would with any other changes.

### Further advice and resources for successful submodule usage

Never `git add .` this is lazy practice anyway but will make bad things happen with submodules.  Try `git add -p` instead. You're welcome.

If you're not sure what to do, ask for help. It's easier to lend a hand along the way than to rescue it later!

Git docs for submodules: <https://git-scm.com/book/en/v2/Git-Tools-Submodules>

A flow chart on surviving submodules from @lornajane: <https://lornajane.net/posts/2016/surviving-git-submodules>


## Troubleshooting

#### I'm having issues with my Docker container

The image may have changed, try rebuild it with the following command:

```
$ docker-compose up --build
```

#### I get an exception `PG::ConnectionBad - could not connect to server: Connection refused` when I try to run the app.

This error indicates that PostgreSQL is not running. If you installed PostgreSQL using `brew` you can get information about how to start it by running:

```
$ brew info postgresql
```

Once PostgreSQL is running you'll need to create and migrate the database. See [Setup](#Setup) for instructions.

## Contributing

Contributions are welcome, please follow [GitHub Flow](https://guides.github.com/introduction/flow/index.html)

