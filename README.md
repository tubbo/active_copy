# ActiveCopy

ActiveCopy is a Rails model layer for reading from static page files.
Inspired by [Jekyll](http://jekyllrb.com), it hacks ActionView to allow for storage
of static page content inside app/views as YAML Front Matter/Markdown.

Although it's still very much a work in progress, ActiveCopy is being
used in production on <http://psychedeli.ca>.

[![Build Status](https://travis-ci.org/tubbo/active_copy.png?branch=master)](https://travis-ci.org/tubbo/active_copy)

## Setup

Add to Gemfile:

```ruby
gem 'active_copy'
```

And generate a model:

```bash
$ rails generate copy article
```

You'll get this as **app/models/article.rb**:

```ruby
class Article < ActiveCopy::Base
  attr_accessible :title
end
```

You'll also see a generator pop up in **lib/generators** that
corresponds to the name you gave the original generator. The `copy`
generator actually "generates a generator" so that you can more easily
generate your custom model records (files).

## Usage

You can define articles in **app/views/articles/content/your-article.md**:

```markdown
---
title: "The title of your article"
---

Hi I'm a static article.
```

Retrieve that article from a param in your route:

```ruby
class ArticlesController < ApplicationController
  def show
    @article = Article.find params[:id]

    respond_with @article
  end
end
```

And show the article in your view:

```haml
#article
  %h1= @article.name
  .content= @article.content
```

## Contributing

You can contribute by making a GitHub pull request. Please include tests
with your feature/bug fix and an ample description as to why you're
fixing the bug.

### Roadmap

- Generators
