# frozen_string_literal: true

require_relative "lib/jekyll-tex-converter/version"

Gem::Specification.new do |s|
    s.name        = "jekyll-tex-converter"
    s.version     = Jekyll::TexConverter::VERSION
    s.summary     = "LaTeX converter for Jekyll."
    s.authors     = "crow02531"
    s.email       = "crow02531@outlook.com"
    s.homepage    = "https://github.com/crow02531/jekyll-tex-converter"
    s.license     = "MIT"

    s.files = [
        "lib/jekyll-tex-converter.rb",
        "lib/jekyll-tex-converter/version.rb",
        "lib/jekyll-tex-converter/engine.rb",
        "lib/jekyll-tex-converter/tex_distribution.rb",
        "lib/jekyll-tex-converter/latex_js.rb",
        "lib/jekyll/converters/tex.rb",

        "script/build-file.lua",

        "LICENSE",
        "README.md"
    ]
end