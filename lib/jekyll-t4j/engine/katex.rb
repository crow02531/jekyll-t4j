# frozen_string_literal: true

require "execjs"

module Jekyll::T4J
    class Engine
        KATEX_CSS_VERSION = "0.16.4"

        @@_katex_js_ = ExecJS.runtime.compile File.read(File.join(__dir__, "katex.js"))

        def self.katex(snippet, options = nil)
            snippet = split_snippet(snippet)
            options = {} unless options
            options[:displayMode] = snippet[1]

            @@_katex_js_.call("katex.renderToString", snippet[0], options)
        end
    end
end