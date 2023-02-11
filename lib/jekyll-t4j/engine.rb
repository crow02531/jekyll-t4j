# frozen_string_literal: true

unless system("latex -version", [:out, :err]=>File::NULL)
    STDERR.puts "You are missing a TeX distribution. Please install:"
    STDERR.puts "  MiKTeX or TeX Live"
    raise "Missing TeX distribution"
end

require "jekyll/cache"

require "jekyll-t4j/engines/dvisvgm"
require "jekyll-t4j/engines/katex"

module Jekyll::T4J
    class Engine
        @@cache = Jekyll::Cache.new "Jekyll::T4J::Engine"

        def initialize(merge_callback)
            @merger = merge_callback
        end

        def header
            result = String.new

            result << "<link rel=\"stylesheet\" href=\"https://unpkg.com/katex@#{KATEX_VERSION}/dist/katex.min.css\">" if @has_katex
            result << "<style>.katex-ext-d{border-radius:0px;display:block;margin:0 auto;}.katex-ext-i{border-radius:0px;display:inline;vertical-align:middle;}</style>" if @has_katex_ext

            result
        end

        def render(snippet, displayMode)
            return "" if (snippet = snippet.strip).empty?

            cache_key = displayMode ? "$$" : "$"
            cache_key = "#{Jekyll::T4J.cfg_pkgs}\\begin{document}\\pagenumbering{gobble}" << cache_key << snippet << cache_key

            cached = @@cache.getset(cache_key) {
                # try katex first
                result = Engine.katex_raw(snippet, {displayMode:, strict: true})

                # otherwise we turn to dvisvgm
                if not result then
                    result = Engine.dvisvgm_raw(
                    <<~HEREDOC
                        \\documentclass{article}
                        \\let\\OldLaTeX\\LaTeX
                        \\renewcommand{\\LaTeX}{\\text{\\OldLaTeX}}
                        \\usepackage{amsmath}\\usepackage{amssymb}#{cache_key}\\end{document}
                    HEREDOC
                    )
                end

                # return
                result.freeze
            }

            if cached.start_with?("<?xml") then
                @has_katex_ext = true

                "<img src=\"#{@merger.(cached, "svg")}\" class=\"#{
                    displayMode ? "katex-ext-d" : "katex-ext-i"
                }\" style=\"height:#{
                    (cached[/height='(\S+?)pt'/, 1].to_f * 0.1).to_s[/\d+\.\d{1,4}/]
                }em\">"
            else
                @has_katex = true

                cached
            end
        end
    end
end