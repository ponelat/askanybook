# AskAnyBook

> **Warning:**
> Any data you provide via the API/web/cli inputs may go through OpenAI, which falls under their Data Policies. See https://openai.com/policies/api-data-usage-policies for more info.

This project is hosted on https://askanybook.ponelat.com and is protected by HTTP Basic authentication. Please reach out if you'd like access.

This is a reproduction of the experiment, https://askmybook.com/, but built with Ruby-on-Rails and React.

There are several parts:

- Script to embed a PDF book. See [Embedding a book](#embedding-a-book)
- Script to ask AI about the book. See [Asking AI about a book](#asking-ai-about-a-book)
- Web app to ask AI about the book. See: https://askanybook.ponelat.com

## Quick start

If you want to get started immediately (using docker-compose, easiest):

- Install docker-compose, so that `docker-compose -h` works.
- Flesh out the `.env` file, see [Environment](#environment)
- (optional, requires Ruby) Embed a custom book, see [Embedding a book](#embedding-a-book)
- Move the silly giraffe book files and put them locally into `books/`
  - [./books-examples/default.manifest.csv]() -> `books/default.manifest.csv`
  - [./books-examples/default.embeds.csv]() -> `books/default.embeds.csv`
- Run with `docker-compose up`.
- Visit http://localhost:80

If you want to get up and running locally, see: [Developing the web app](#developing-the-web-app)

## Environment

**Setting up access with .env and API key(s)**

This project depends on OpenAI for fetching embeddings and completions. You will need an API key to use it.

- Copy [.env.template](.env.template) to `.env`
- Fill out, at least, the OpenAI API Key

You can get an API key from https://platform.openai.com/account/api-keys

To fill out the `SECRET_KEY_BASE`, you can locally run `rails secret` and use that output. It is needed for running Rails in production environments and is mounted on the docker container when it is run.

## The scripts

Start by embedding a book, then you can ask it questions.

> **Note:**
> If you leave out `--name`, it will use `default`. This convention is true of the scripts as well as the web app.

### Embedding a book

To get anywhere, you'll need to embed a PDF book, which will run each page into AI and create two files: `{name}.manifest.csv` and `{name}.embeds.csv`. These files can then be used to ask questions using the contents of the book.

```sh
Usage: bin/embedbook [options]

	OPENAI_API_KEY (required). As ENV variable or entry in .env

    -f, --file FILENAME              Specify input CSV file [id,content] (required)
    -n, --name NAME                  Specify the name of the book, else it will be called "default" for use with the web app
    -v, --verbose                    Dump debugging info
```

This repo comes with a silly example, [books-examples/giraffe.pdf](books-examples/giraffe.pdf). To embed it, run:

```sh
# Embed the example book
bin/embedbook --file books-examples/giraffe.pdf
```

You should see it embed two pages and create:
- `books/default.manifest.csv`
- `books/default.embeds.csv`

The manifest file includes the template, which you should tinker with. The embeds file contains all the embeddings and content. The manifest has a link to the embeds file, which is also configurable.

### Asking AI about a book

To ask a question of an embedding book, you can use `bin/askbook`. 

```sh
Usage: askbook --book ./book.manifest.csv --question QUESTION

	OPENAI_API_KEY (required). As ENV variable or entry in .env

    -b, --book FILENAME              Specify persona CSV file [embeds_path,prompt_template] else defaults to books/default.manifest.csv
    -q, --question QUESTION          The question to ask the book (required). Typically wrapped in quotes
    -v, --verbose                    Dump debugging info
```

Based on our giraffe example, you could run:

```sh
# Ask the book a question
bin/askbook --book books/default.manifest.csv --question "What is this book about?"

# Or you can leave out book to use books/default.manifest.csv
bin/askbook --question "What is this book about?"
```

You should get an answer related to giraffes.

> **Note:**
> The giraffe example isn't comprehensive of the features of askbook but helps to serve as a smoke test.

# Developing the web app

- This is a Ruby on Rails project. 
- It has a create-react-app front-end.

**Requirements**

- Ruby (3.1+ recommended)
- Node.js (18+ recommended)
- Docker (optional, for deployments)
- API keys, see: [Environment](#environment) above.

If you're a Nix(OS) geek, see [Set up in Nix](#set-up-in-nix) below for instructions.

**Installing dependencies**

To get your gems and npm packages, run the following.

```sh
bundle install
npm i --prefix frontend/
```

Then fire up a development server with 

```sh
foreman start -f Procfile.dev
```

Two servers will be running:
- https://localhost:5100 - front-end dev-server. 
- https://localhost:5000 - rails back-end

The front-end is in the [frontend/](frontend/) folder exclusively, and any changes there should auto-update with the dev-server running. Because of the proxy nature, API calls from the front-end can be made on the same URL and will be proxied to the rails server. For example, `POST /ask` from the front-end will proxy to `http://localhost:5000/ask`.

> See: https://create-react-app.dev/docs/proxying-api-requests-in-development/ for more info

The Rails server will also respond to changes in `.rb` files.

### Set up in Nix

If you have Nix, you can simply run `nix-shell` and you should be good. This has been tested on x86_64.

To add gems, you will need to run `nix/add-gem.sh <gemname>`, which will add to `Gemfile` and run `bundix` on the `Gemfile.lock`. Then you'll need to enter a new shell with `nix-shell` (from root folder). If you modify `Gemfile` manually, you can run `nix/bundle.sh` to only compile the `Gemfile.lock` to `gemset.nix`.

To add npm packages, you can use npm as you would locally.

## Testing

Currently, only parts of the back-end have unit tests. These are aimed at the business logic around embeddings and how they work. To run the test suite:

- `rails test`

> **Note: The test suite is not a blocker for either committing code or building the Docker image. Please ensure tests pass manually before committing.

# Building and deploying locally

This app was designed to work in Docker Compose. You can run `docker-compose up` locally. 

That and an `.env` file and a `books/default.{manifest,embeds}.csv` are all you need to start the app up and play with it.

It will be running on http://localhost:80.

## Building the Docker image

First, you'll need to build a Docker image. You can modify the `.env` file to change the name of the Docker image. 
Then run 

```sh
rake docker
```

Which will build the web app (front-end and back-end) inside the Docker context so you do not need to build the app locally beforehand.

> **Note:**
> The Docker build isn't optimized, so you might end up downloading the earth and even minor changes can result in a long (minutes) build time. But at least it should work anywhere!

You can also use `rake docker:push` to push the image. This requires you to have logged into Docker on the command line. To do that, you can use:

```sh
# For GitHub Container Registry
# See: https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry 

docker login [ghcr.io]

# For Docker Hub
docker login
```

Then follow the prompts for username and password (or GitHub Token).

# Building and deploying the web app to production

To deploy the app, you can use [./docker-compose.production.yml](./docker-compose.production.yml) and a copy of the `.env` file.
To get the `.env` file, see [Environment](#environment).

You will need to tweak this Compose file, specifically the hostname for TLS/HTTPS.

There is a helper script, [./deploy.sh](./deploy.sh), that builds, pushes, and redeploy an EC2 instance.
