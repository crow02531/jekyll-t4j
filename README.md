# Jekyll::T4J

TeX/LaTeX support for Jekyll.

## Introduction

This plugin integrate Jekyll with several (la)tex2html/(la)tex2svg conversion engines to convert your latex content. If you find MathJax or KaTeX can not cover your needs to write complex articles(i.e. LaTeX using chemfig), this plugin may help you a lot.

Feel free to write any LaTeX! &#x1F389;

## Usage

Currently there are two ways to use jekyll-t4j.

### 1. `.tex` File

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

### 2. `tex_snippet` Liquid Tag

If you just want to embed a piece of equation or tikz generated picture in `.md` or `.html`. You may love `tex_snippet`. Its usage is pretty simple.

```
<!-- In a markdown file -->
{% tex_snippet chemfig %}
    \chemfig{C(-[:135])(<:[:200])(<[:-130])-\charge{[circle]10=\:,80=\:}{O}-[:-60]H}
{% endtex_snippet %}
```

The tag `tex_snippet` receives package names as argument(multiple packages are seperated by `,` i.e. `chemfig,mhchem`). And you don't need to write `\documentclass{article}\begin{document}...\end{document}`.

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

## Multiple Engines

jekyll-t4j employs multiple engines to convert your latex content. When converting we will analyse your latex code briefly and choose one of these engines to do the convertion. By now 3 engines are available.

### 1. TeX4ht

TODO

### 2. dvisvgm

TODO

### 3. LaTeX.js

TODO