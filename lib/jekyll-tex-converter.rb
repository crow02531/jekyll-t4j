require "jekyll"

require "jekyll-tex-converter/version"
require "jekyll/converters/tex"

module Jekyll
    module TexConverter

        # the absolute path of the gem
        ROOT = File.expand_path("../", File.dirname(__FILE__))

        # the relative path of the cache file
        CACHE_ROOT = ".jekyll-cache/tex"

        # clean the cache file
        def TexConverter.cache_clean
            FileUtils.rm_r CACHE_ROOT if File.exist?(CACHE_ROOT)
            FileUtils.mkdir_p CACHE_ROOT
        end
    end
end

# disable excerpt for '.tex'
Jekyll::Hooks.register :documents, :post_init do |doc|
    if doc.extname =~ Jekyll::Converters::Tex::EXTENSION_PATTERN
        doc.data["excerpt_separator"] = ""
    end
end