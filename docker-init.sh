#!/usr/bin/env bash

rake db:{create,migrate,seed}
rails server -b 0.0.0.0
