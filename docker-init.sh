#!/usr/bin/env bash

rake db:{create,migrate,seed}
rails server
