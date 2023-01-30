# Jekyll::TexConverter

Convert your `.tex` Jekyll content.

## Introduction

This plugin integrate Jekyll with your local TeX distribution to convert `.tex` to `.html`. If you find MathJax or KaTeX can not cover your needs to write complex articles(i.e. LaTeX using chemfig) in Jekyll, this plugin may help you a lot.

Feel free to write any LaTeX! &#x1F389;

## Installation

First of all, you need to have a TeX distribution. Just download and install [MikTeX](https://miktex.org/) or [Tex Live](https://tug.org/texlive/).

Then, install the plugin just as other Jekyll plugins. Add this line to your application's Gemfile:

```ruby
gem 'jekyll-tex-converter'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install jekyll-tex-converter
```

Lastly, add it to your `_config.yml` file:

```yaml
plugins:
    - jekyll-tex-converter
```