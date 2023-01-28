require "jekyll"

require "jekyll-tex-converter/version"
require "jekyll/converters/tex"

module Jekyll
    module TexConverter
        ROOT = File.expand_path("../", File.dirname(__FILE__))
    end
end