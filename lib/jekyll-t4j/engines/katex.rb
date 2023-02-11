# frozen_string_literal: true

require "execjs"

module Jekyll::T4J
    class Engine
        KATEX_VERSION = "0.16.4"

        @@_katex_js = ExecJS.runtime.compile File.read(File.join(__dir__, "katex.js"))

        def self.katex_raw(src, options)
            @@_katex_js.call("katex.renderToString", src, options)
        rescue
            return nil
        end
    end
end