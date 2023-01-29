require_relative "lib/jekyll-tex-converter/version"

Gem::Specification.new do |s|
    s.name        = "jekyll-tex-converter"
    s.version     = Jekyll::TexConverter::VERSION
    s.summary     = "TeX converter for Jekyll."
    s.authors     = "crow02531"
    s.email       = "crow02531@outlook.com"
    s.homepage    = "https://github.com/crow02531/jekyll-tex-converter"
    s.license     = "MIT"

    s.files = [
        "lib/jekyll-tex-converter.rb",
        "lib/jekyll-tex-converter/version.rb",
        "lib/jekyll/converters/tex.rb",

        "script/build-normal.lua",
        "script/build-inline.lua",

        "LICENSE",
        "README.md"
    ]
end