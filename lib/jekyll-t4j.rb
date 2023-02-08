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
        @@cfg_pkgs = (cfg and (cfg = cfg["packages"])) ? parse_cfg_pkgs(cfg) : ""
    end

    def self.parse_cfg_pkgs(cfg)
        ret = String.new

        for p in cfg
            raise "Illegal config: #{p}" unless p.match(/\s*([\w-]+)(\[[^\[\]]*\])?\s*/)
            ret << "\\usepackage#{$2}{#{$1}}"
        end

        ret
    end
end

require "jekyll-t4j/merger"
require "jekyll-t4j/engines"
require "jekyll-t4j/renderer"