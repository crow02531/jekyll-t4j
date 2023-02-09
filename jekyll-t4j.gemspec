# frozen_string_literal: true

require_relative "lib/jekyll-t4j/version"

Gem::Specification.new do |s|
    s.name        = "jekyll-t4j"
    s.version     = Jekyll::T4J::VERSION
    s.summary     = "LaTeX support for Jekyll."
    s.authors     = "crow02531"
    s.email       = "crow02531@outlook.com"
    s.homepage    = "https://github.com/crow02531/jekyll-t4j"
    s.license     = "MIT"

    s.files = [
        "lib/jekyll-t4j.rb",
        "lib/jekyll-t4j/version.rb",
        "lib/jekyll-t4j/merger.rb",
        "lib/jekyll-t4j/renderer.rb",
        "lib/jekyll-t4j/engines.rb",
        "lib/jekyll-t4j/engines/dvisvgm.rb",

        "LICENSE",
        "README.md"
    ]

    s.add_runtime_dependency "jekyll", "~> 4.2"
    s.requirements << "TeX distribution"
end