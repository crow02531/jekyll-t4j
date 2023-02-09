# Jekyll::T4J

jekyll-t4j is a plugin integrating Jekyll with your local TeX distribution. It enables Jekyll to cope with LaTeX code in your site. If you find MathJax or KaTeX can not cover your needs to write complex articles(i.e. LaTeX using chemfig), this plugin may help you a lot.

Feel free to write any LaTeX! &#x1F389;

## Usage

For instance, write a post `2023-02-04-hello-latex.md` and fill it with:

```
---
layout: default
title:  Hello LaTeX
date:   2023-02-04 14:53:32 +0800
---

This is an inline math $$r=\sqrt{x^2+y^2}$$.

$$\chemfig{*6((--[::-60]HO)-=(-O-[:30])-(-OH)=-=)}$$

And this is vanillyl alcohol.
```

Then, open your `_config.yml` file and write:

```yaml
t4j:
  packages:
    - chemfig
```

Finally, build your site, complete!

## Installation

First of all, you need to have a TeX distribution. Just download and install [MikTeX](https://miktex.org/) or [Tex Live](https://tug.org/texlive/).

Then, install jekyll-t4j just as other Jekyll plugins. Add this line to your application's Gemfile:

```ruby
gem 'jekyll-t4j'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install jekyll-t4j
```

Lastly, add it to your `_config.yml` file:

```yaml
plugins:
    - jekyll-t4j
```