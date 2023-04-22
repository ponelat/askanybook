**WARNING**

>  Any data you provide via the API/web/cli inputs may go through OpenAI, which falls under their Data Policies. See https://openai.com/policies/api-data-usage-policies for more info.

# Run locally

- This is a ruby on rails project. 
- It connects to 3rd party APIs, which will require API keys (they'll go into .env file)

## Keys

Go grab some API keys

- OpenAI: https://platform.openai.com/account/api-keys

Copy the `.env.temlpate` file to `.env` and fill out the API key(s).

## Scripts

There are the following scripts
- `bin/askbook`

**bin/askbook**

Called with a single argument (wrap in quotes to be sure). 
This command will ask OpenAI a question, and slowly type out the response.

## Rails server

**Requirements:**

- Ruby (tested on 2.7)
- (possibly build tools for ruby / sqlite)
**or**
- nix (everything will be magical)

Get ruby on rails up and running...

```sh
# Install ruby gems
bundle 
rails server
```

A quick test of `http://localhost:3000/health` should return `{"ok": true}`
