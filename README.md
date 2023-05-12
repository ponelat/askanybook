# AskAnyBook

> **Warning**: Any data you provide via the API/web/cli inputs may go through OpenAI, which falls under their Data Policies. See https://openai.com/policies/api-data-usage-policies for more info.

This project is hosted on https://askanybook.ponelat.com and is protected by HTTP Basic authentication. Please reach out if you'd like access.

This is a reproduction of the experiment, https://askmybook.com/, but built with Ruby-on-Rails and React.

There are several parts:

- Web app to ask AI about the book. See: https://askanybook.ponelat.com
- Scripts to embed and ask a PDF book. See [Embedding a book](#embedding-a-book) and [Asking AI about a book](#asking-ai-about-a-book)

## Quick start

You'll need **Ruby (3.1)** and **Node.js (18)** installed.

```sh
# Get the Ruby stuff going
bundle install

# Get the Node.js stuff going
npm i --prefix frontend/
```

**...Then:** 

- Copy [./env.template](./.env.template) to `.env`
- Grab an [OpenAI API Key](https://platform.openai.com/account/api-keys) and add it to `.env`
- Embed a book. You can use the example book:

```sh
# Embed a book (adds it to books )
bin/embedbook -f books-examples/giraffe.pdf
```

- Start foreman

```sh
# Start local servers
foremand start -f Procfile.dev

# http://localhost:5100 (react server)
# http://localhost:5000 (rails server)
```

Now go visit the react server, it will proxy to rails as needed. 

<h2> <a href="http://localhost:5100">http://localhost:5100</a></h2>

For more info on requirements and env variables, see below.

## ~~Quick~~ Slow start

See [README-DEPLOY.md](./README-DEPLOY.md) for running the app in docker-compose, both locally and on a production server.

See [Set up in Nix](#set-up-in-nix) for using Nix to manage local dependencies like Ruby and Node.js

### Environment

**Setting up access with .env and API key(s)**

This project depends on OpenAI for fetching embeddings and completions. You will need an API key to use it.

- Copy [.env.template](.env.template) to `.env`
- Fill out, at least, the OpenAI API Key
- For docker-compose production, fill out the `SECRET_KEY_BASE` and optionally the `HTTP_BASIC_USERNAME` and `HTTP_BASIC_PASSWORD`

> To fill out the `SECRET_KEY_BASE`, you can locally run `rails secret` and use that output. It is needed for running Rails in production environments and is mounted on the docker container when it is run.


### Requirements

This is a Ruby on Rails project with a Create-React-App front-end.

- Ruby (3.1+ recommended)
- Node.js (18+ recommended)
- Docker (optional, for deployments)
- API keys, see: [Environment](#environment) above.

If you're a Nix(OS) geek, see [Set up in Nix](#set-up-in-nix) below for instructions.

The front-end is in the [frontend/](frontend/) folder exclusively. The react server will proxy, see [https://create-react-app.dev](https://create-react-app.dev/docs/proxying-api-requests-in-development/) for more info.
The Rails server will also respond to changes in `.rb` files.

### Set up in Nix

If you have Nix, you can simply run `nix-shell` and you should be good.
This has been tested on x86_64.

To add gems, you will need to run `nix/add-gem.sh <gemname>`, which will add to `Gemfile` and run `bundix` on the `Gemfile.lock`. Then you'll need to enter a new shell with `nix-shell` (from root folder). If you modify `Gemfile` manually, you can run `nix/bundle.sh` to only compile the `Gemfile.lock` to `gemset.nix`.

To add npm packages, you can use npm as you would locally.

### Testing

Currently, only parts of the back-end have unit tests. These are aimed at the business logic around embeddings and how they work. To run the test suite:

- `rails test`

> **Note**: The test suite is not a blocker for either committing code or building the Docker image. Please ensure tests pass manually before committing.


## The scripts


For this project, Embedding refers to extracting vector embeddings, which are numerical "coordinates", from a PDF document. Each page of the PDF is individually processed, and OpenAI is the backend to provide the embeddings.
These `embeddings` can be thought of as coordinates in AI-space. Two ideas that are conceptually similar will be close-by in this coordinate system.
An example of this is a question and answer pair.

To answer questions of a book, we can gather context by sorting the pages by how close they are to the question (specifically, comparing the question's embeddings with those of the PDF pages). The sorted pages can then be used in a prompt alongside the question. 

![AI Coordinate Space Diagram](./images/ai-coordinate-space.png)

You can embed the example `giraffe.pdf` book, or any PDF that you have permission to do so.

> **Note**: If you leave out `--name`, it will use `default`. This convention is true of the scripts as well as the web app.


> **Warning**: Any data you provide via the API/web/cli inputs may go through OpenAI, which falls under their Data Policies. See https://openai.com/policies/api-data-usage-policies for more info.


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

> **Note**: The giraffe example isn't comprehensive of the features of askbook but helps to serve as a smoke test.
