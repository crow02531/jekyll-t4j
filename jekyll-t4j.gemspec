# frozen_string_literal: true

require_relative "lib/jekyll-t4j/version"

Gem::Specification.new do |s|
    s.name        = "jekyll-t4j"
    s.version     = Jekyll::T4J::VERSION
    s.summary     = "TeX/LaTeX support for Jekyll."
    s.authors     = "crow02531"
    s.email       = "crow02531@outlook.com"
    s.homepage    = "https://github.com/crow02531/jekyll-t4j"
    s.license     = "MIT"

    s.files = [
        "lib/jekyll-t4j.rb",
        "lib/jekyll-t4j/version.rb",
        "lib/jekyll-t4j/analyzer.rb",
        "lib/jekyll-t4j/engines/engine.rb",
        "lib/jekyll-t4j/engines/tex4ht.rb",
        "lib/jekyll-t4j/engines/dvisvgm.rb",
        "lib/jekyll-t4j/engines/latex_js.rb",
        "lib/jekyll/merger.rb",
        "lib/jekyll/converters/tex.rb",
        "lib/jekyll/tags/tex_snippet.rb",

        "script/build-file.lua",

        "LICENSE",
        "README.md"
    ]
end