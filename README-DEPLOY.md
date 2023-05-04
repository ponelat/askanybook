# AskAnyBook - Deploying

This app was designed to work in Docker Compose. You can run `docker-compose up` locally. 

**Requirements for a deployment:**

- [docker-compose.production.yml](./docker-compose.production.yml)
  - **NOTE**: You will need to change the hostname in docker-coompose file for TLS to work
- `.env`, see [Environment](./README.md#environment)
- `books/` directory with `default.manifest.csv` and `default.embeds.csv`. See [Embedding a book](./README.md#embedding-a-book)

**On your host server**:

```sh
# To run in daemon mode

docker-compose -f ./docker-compose.production.yml up -d
```

```sh
# To pull new images and redeploy

docker-compose -f ./docker-compose.production.yml pull
docker-compose -f ./docker-compose.production.yml up -d
```


> There is a helper script, [./deploy.sh](./deploy.sh), that builds, pushes, and redeploy an EC2 instance. It can be tweaked to suit your environment.


## Running docker-compose locally

There is a local version of in [docker-compose.yml](./docker-compose.yml). This version is different in that it does NOT run TLS, so only have HTTP.

```sh
# To run docker-compose locally (ctrl-c to stop)

rake docker:build

docker-compose up
# Visit http://localhost:80 or your docker machine IP:80
```


**This version uses:**

- Uses the local `.env` file
- Uses the local `books/` file
- Uses the local `sqlite/` database


## Building the Docker image

First, you'll need to build a Docker image. You can modify the `.env` file to change the name of the Docker image. 
Then run 

```sh
# Build docker iamge
rake docker

# which defaults to
rake docker:build
```

Which will build the web app (front-end and back-end) inside the Docker context so you do not need to build the app locally beforehand.

> **Note:**
> The Docker build isn't optimized, so you might end up downloading the earth and even minor changes can result in a long (minutes) build time. But at least it should work anywhere!

You can use `rake docker:push` to push the image. This requires you to have logged into Docker on the command line. To do that, you can use:

```sh
# For GitHub Container Registry
# See: https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry 
docker login [ghcr.io]

# For Docker Hub
docker login

# Then follow the prompts for username and password (or GitHub Token).
# ...
```


