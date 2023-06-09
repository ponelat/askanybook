# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

namespace :docker do
  desc 'Build and run docker image'
  task build: :environment do
    sh "docker build -t #{ENV['DOCKER_IMAGE']} ."
  end

  task run: :environment do
    # NOTE: be sure to add -i (input) and -t (tty) else the docker container won't die after ctrl-c.
    sh "docker run --env-file=.env --rm -it -p 3000:3000 #{ENV['DOCKER_IMAGE']} "
  end

  task push: :environment do
    sh "docker push #{ENV['DOCKER_IMAGE']}"
  end
end

task docker: 'docker:build'

namespace :frontend do
  desc 'Build frontend and copy to public folder'
  task build: :environment do
    # Run npm build
    FileUtils.mkdir_p('public/assets/spa', verbose: true)

    # Use /assets to keep close to rails convention

    sh 'PUBLIC_URL="/assets/spa" npm run build --prefix frontend'

    # Copy the index.html into public. Rails doesn't like rendering anything in public/assets
    FileUtils.cp('frontend/build/index.html', 'public/index.html', verbose: true)

    # Copy the rest of the public folder to Rails assets directory
    FileUtils.cp_r('frontend/build/.', 'public/assets/spa/', verbose: true)
  end

  desc 'Clean the public folder'
  task clean: :environment do
    FileUtils.rm_rf('public/index.html', verbose: true)
    FileUtils.rm_rf('public/assets/spa', verbose: true)
  end
end

task frontend: 'frontend:build'
