require "jekyll"

require "jekyll-tex-converter/version"
require "jekyll-tex-converter/engine"
require "jekyll-tex-converter/tex_distribution"
require "jekyll/converters/tex"

module Jekyll
    module TexConverter

        # the absolute path of the gem
        ROOT = File.expand_path("../", File.dirname(__FILE__))
    end
end

# disable excerpt for '.tex'
Jekyll::Hooks.register :documents, :post_init do |doc|
    if doc.extname =~ Jekyll::Converters::Tex::EXTENSION_PATTERN
        doc.data["excerpt_separator"] = ""
    end
end