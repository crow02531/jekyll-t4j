require "jekyll"

require "jekyll-tex-converter/version"
require "jekyll/converters/tex"

module Jekyll
    module TexConverter
        ROOT = File.expand_path("../", File.dirname(__FILE__))
    end
end

# disable excerpt for '.tex'
Jekyll::Hooks.register :documents, :post_init do |post|
    if post.extname == ".tex"
        post.data["excerpt_separator"] = ""
    end
end