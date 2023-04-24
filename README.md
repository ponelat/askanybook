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

## Stuff to do

- [ ] Test embedding distance
  -  `[0.1, 0.1, 0.1]` should be closer to `[0.2, 0.2, 0.2]` than `[0.9, 0.9, 0.9]`
- [ ] Generate some embeddings, like the following...
  ```csv
  id,content,0, 1, ... MAX
  apple,a juicy apple,...
  banana,a rotten banana,...
  ostrich,an old male ostrich,...
  giraffe,a young female giraffe,...
  newspapaer,the terrible newspaper,...
  fruit,fruit,...
  yellow,yellow,...
  animal,animal,...

  ```
- [ ] Test semantic distance
  - apple -> fruit is closer than newspaper -> fruit.
  - given "yellow", sort the embeddings. First two should include "banana" and "giraffe".
- [ ] Test pdf to embeddings (csv)
  - Create PDF with following pages (based on embeddings fixture)
  ```txt
  page 1 -> a juicy apple
  page 2 -> a rotten banana 
  ...
  page 8 -> animal
  ```
  - Given a (mock) "get_embedding", it should create `[id, content, ...embeddings]`. Don't think I'll test CSV creation though.
- [ ] Test truncating pages to fit openai get_embedding. Tokens or character length.
