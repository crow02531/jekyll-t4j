# frozen_string_literal: true

require "jekyll"

require "jekyll-t4j/version"
require "jekyll-t4j/analyzer"
require "jekyll-t4j/engines/engine"
require "jekyll-t4j/engines/tex4ht"
require "jekyll-t4j/engines/dvisvgm"
require "jekyll-t4j/engines/latex_js"
require "jekyll/merger"
require "jekyll/converters/tex"
require "jekyll/tags/tex_snippet"

module Jekyll
    module T4J

        # the absolute path of the gem
        ROOT = File.expand_path("../", File.dirname(__FILE__)).freeze
    end
end