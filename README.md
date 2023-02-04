# Jekyll::TexConverter

Convert your `.tex` Jekyll content.

## Introduction

This plugin integrate Jekyll with several latex2html engines to convert `.tex` to `.html`. If you find MathJax or KaTeX can not cover your needs to write complex articles(i.e. LaTeX using chemfig), this plugin may help you a lot.

Feel free to write any LaTeX! &#x1F389;

## Usage

For instance, write a post `2023-02-04-hello-latex.tex` and fill it with

```
---
layout: default
title:  Hello LaTeX
date:   2023-02-04 14:53:32 +0800
---

\documentclass{article}
\begin{document}
Hi! This is \LaTeX{}.
\end{document}
```

Then build your site, complete!

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

## Multiple Engines

The plugin employs multiple engines to convert your latex content. When converting we will analyse your latex code briefly and choose one of these engines to do the convertion. Currently only two engines are available.

### 1. Local Tex Distribution

This is why you have to install TexLive or MikTeX before you use this plugin. We use [tex4ht](https://www.tug.org/tex4ht/) to convert latex to html. tex4ht supports almost all packages.

### 2. LaTeX.js

Although tex4ht covers nearly all packages, but it's pretty slow. So when we find your latex code use no packages or packages that are supported by [LaTeX.js](https://latex.js.org/), we will choose this engine to do the job. It's faster than tex4ht.