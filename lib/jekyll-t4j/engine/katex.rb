# frozen_string_literal: true

require "execjs"

module Jekyll::T4J
    module Engine
        KATEX_VERSION = "0.16.4"

        @@_katex_js_ = nil

        def self.setup_katex
            if not @@_katex_js_ then
                src = File.read(File.join(__dir__, "katex.js"))
                src << File.read(File.join(__dir__, "katex.mhchem.js")) if Jekyll::T4J.cfg_pkgs.include?("mhchem")

                @@_katex_js_ = ExecJS.runtime.compile(src)
            end
        end

        def self.katex_raw(snippet, options = nil)
            snippet = split_snippet(snippet)
            options = {} unless options
            options[:displayMode] = snippet[1]

            @@_katex_js_.call("katex.renderToString", snippet[0], options)
        end
    end
end