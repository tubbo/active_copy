# ActiveCopy

ActiveCopy is a Rails model layer for reading from static page files.
Inspired by [Jekyll][jekyll], it hacks ActionView to allow for storage
of static page content inside app/views as YAML Front Matter/Markdown.

Although it's still very much a work 

## Setup

Add to Gemfile:

```ruby
gem 'active_copy'
```

And generate a model:

```bash
$ rails generate active_copy article
```

You'll get this as **app/models/article.rb**:

```ruby
class Article < ActiveCopy::Base
  attr_accessible :title
end
```

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
