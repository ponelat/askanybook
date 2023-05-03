# AskAnyBook

> **warning**
>  Any data you provide via the API/web/cli inputs may go through OpenAI, which falls under their Data Policies. See https://openai.com/policies/api-data-usage-policies for more info.

Hosted on https://askanybook.ponelat.com.
It is protected by HTTP Basic authentication. Please reach out if you'd like access.


This is a reproduction of the experiment, https://askmybook.com/. But built with Ruby-on-Rails and React.

There are several parts:
- Script to embed a PDF book. See 
- Script to ask AI about the book. See
- Web app to ask AI about the book.

## Environment

**Setting up access with .env and API key(s)**
This project depends on OpenAI for fetching embeddings and completions. You will need an API key to use it.

- Copy [.env.template](.env.template) to .env 
- Fill out, at least, the OpenAI API Key

You can get an API key from https://platform.openai.com/account/api-keys


## The scripts

Start by embedding a book then you can ask it questions.


### Embedding a book

To get anywhere you'll need to embed a PDF book, which will run each page into AI and create two files, a `{name}.manifest.csv` and `{name}.embeds.csv`. These files can then be used to ask questions using the contents of the book.

```sh
Usage: bin/embedbook [options]

	OPENAI_API_KEY (required). As ENV variable or entry in .env

    -f, --file FILENAME              Specify input CSV file [id,content] (required)
    -v, --verbose                    Dump debugging info
```

This repo comes with a silly example, [books-examples/giraffe.pdf](books-examples/giraffe.pdf). To embed it..

```sh
bin/embedbook --file books-examples/giraffe.pdf
```

You should see it embed two pages and create
- `books/giraffe.manifest.csv`
- `books/giraffe.embeds.csv`

The manifest file includes the template, which you should tinker with. The embeds file contains all the embeddings and content. The manifest has a link to the embeds file, which is also configurable.

### Asking AI about a book

To ask a question of an embedding book, you can use `bin/askbook`. 

```sh
Usage: askbook --book ./book.manifest.csv --question QUESTION

	OPENAI_API_KEY (required). As ENV variable or entry in .env

    -b, --book FILENAME              Specify persona CSV file [embeds_path,prompt_template] (required)
    -q, --question QUESTION          The question to ask the book (required). Typically wrapped in quotes
    -v, --verbose                    Dump debugging info

```

Based on our girrafe example, you could run...
```sh
bin/askbook --book books/giraffe.manifest.csv --question "What is this book about?"
```

You should get an answer related to giraffes.

> **note**
>  The giraffe example isn't comprehensive of the features of askbook, but helps to sever as a smoke test.


# Developing the web app

- This is a ruby on rails project. 
- It has a create-react-app front-end.

**Requirements**

- Ruby (3.1+ reccommended)
- Node.js (18+ reccommended)
- Docker (optional, for deployments)
- API keys, see: [Environment](#environment) above.

If you're a Nix(OS) geek, see [Set up in Nix](#setup-in-nix) below for instructions.


**Installing dependencies**

To get your gems and npm packages, run the following.

```sh
bundle install
npm i --prefix frontend/
```

Then fire up a development server with 
```sh
forman start -f Procfile.dev
```

Two servers will be running.
- https://localhost:5100 - front-end dev-server. 
- https://localhost:5000 - rails back-end

The front-end is in the [frontend/](frontend/) folder exclusively, and any changes there should auto-update with the dev-server running. 
Because of the proxy nature, API calls from the front-end can be made on the same URL and will be proxied to the rails server. E.g.: `POST /ask` from the front-end, will proxy to `http://localhost:5000/ask`.

> See: https://create-react-app.dev/docs/proxying-api-requests-in-development/ for more info

The rails server will also respond to changes in .rb files. 

### Set up in Nix

If you have nix, you can simply run `nix-shell` and you should be good.
Tested on x86_64.

To add gems, you will need to run `nix/add-gem.sh <gemname>` which will add to Gemfile and run bundix on the Gemfile.lock. Then you'll need to ener a new shell with `nix-shell` (from root folder). If you modify Gemfile manually, you can run `nix/bundle.sh` to only compile the Gemfile.lock to gemset.nix.

To add npm packages, you can use npm as you would locally. 

## Testing

Currently only parts of the back-end have unit tests. These are aimed at the business logic around embeddings and hwo they work. To run the test suite:

- `rails test`

> **note**
> The test suite is not a blocker for either commiting code, or building the docker image. Please ensure tests pass manually before committing. 


# Deploying the web app

This app was designed to work in docker-compose.
First you'll need to build a docker image, you can modify `.env` file to change the name of the docker image. 
Then run 
```sh
rake docker
```

Which will build the web app (fron-end and back-end) inside the docker context, so you do not need to build the app locally, beforehand.

> **note**
> The docker build isn't optimized, so you might end up downloading the earth and even minor changes can result in a long (minutes) build time. But at least should wokr anywhere!

You can also use `rake docker:push` to push the image. This requires you to have logged into docker on the command line. To do that, you can use:

```sh
# For GitHub container registry
# See: https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry 

docker login [ghcr.io]

# For docker hub
docker login
```

The follow the prompts for username and password (or GitHub Token).
