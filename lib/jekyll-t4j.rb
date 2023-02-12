# frozen_string_literal: true

require "jekyll"

require "jekyll-t4j/version"

module Jekyll::T4J
    @@cfg_pkgs

    def self.cfg_pkgs
        @@cfg_pkgs
    end

    # initialize plugin
    Jekyll::Hooks.register :site, :after_init do |site|
        cfg = site.config["t4j"]

        if cfg and (cfg = cfg["packages"]) then
            pkgs = String.new

            for p in cfg
                raise "Illegal config: #{p}" unless p.match(/\s*([\w-]+)(\[[^\[\]]*\])?\s*/)
                pkgs << "\\usepackage#{$2}{#{$1}}"
            end

            @@cfg_pkgs = pkgs
        else
            @@cfg_pkgs = ""
        end
    end
end

require "jekyll-t4j/merger"
require "jekyll-t4j/engine"
require "jekyll-t4j/renderer"