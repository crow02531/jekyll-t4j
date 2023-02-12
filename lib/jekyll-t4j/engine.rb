# frozen_string_literal: true

unless system("latex -version", [:out, :err]=>File::NULL)
    STDERR.puts "You are missing a TeX distribution. Please install:"
    STDERR.puts "  MiKTeX or TeX Live"
    raise "Missing TeX distribution"
end

require "jekyll/cache"

require "jekyll-t4j/engine/dvisvgm"
require "jekyll-t4j/engine/katex"

module Jekyll::T4J
    module Engine
        @@cache_katex = Jekyll::Cache.new "Jekyll::T4J::Katex"
        @@cache_dvisvgm = Jekyll::Cache.new "Jekyll::T4J::Dvisvgm"

        @@header = <<~HEREDOC
            <link rel=\"stylesheet\" href=\"https://unpkg.com/katex@#{KATEX_CSS_VERSION}/dist/katex.min.css\">
            <style>
                .katex-ext-d {
                    border-radius: 0px;
                    display: block;
                    margin: 5px auto;
                }
                .katex-ext-i {
                    border-radius: 0px;
                    display: inline;
                    vertical-align: middle;
                }
            </style>
        HEREDOC

        def self.header
            @@header
        end

        def self.render(snippets, merger)
            gen = ->(svg_data, displayMode) {
                "<img src=\"#{merger.(svg_data, ".svg")}\" class=\"#{
                    displayMode ? "katex-ext-d" : "katex-ext-i"
                }\" style=\"height:#{
                    (svg_data[/height='(\S+?)pt'/, 1].to_f * 0.1).to_s[/\d+\.\d{1,4}/]
                }em\">"
            }

            # normalize 'snippets'
            snippets.map! {|s|
                if not s.start_with?("\\") then
                    s = split_snippet(s)
                    s = s[1] ? "\\[#{s[0]}\\]" : "\\(#{s[0]}\\)"
                end

                s
            }

            # fill 'snippets' with katex and cached dvisvgm
            unset = []
            uncached = {}
            snippets.each_index {|i|
                s = snippets[i]
                r = @@cache_katex.getset(s) {
                    begin
                        katex_raw(s, {strict: true})
                    rescue
                        "NIL"
                    end
                }

                if r == "NIL" then
                    begin
                        r = gen.(@@cache_dvisvgm[Jekyll::T4J.cfg_pkgs + s], is_display_mode?(s))
                    rescue
                        uncached[s] = r = nil
                        unset << [i, s]
                    end
                end

                snippets[i] = r
            }

            # render 'uncached'
            if not uncached.empty? then
                # bulk render 'uncached'
                begin
                    uncached_snippets = uncached.keys
                    rendered = dvisvgm_raw_bulk(uncached_snippets)
                    rendered.each_index {|i| uncached[uncached_snippets[i]] = rendered[i]}
                end

                # flush 'uncached' to 'snippets' and cache them
                unset.each {|b|
                    s = b[1]
                    snippets[b[0]] = gen.(uncached[s], is_display_mode?(s))
                    @@cache_dvisvgm[Jekyll::T4J.cfg_pkgs + s] = uncached[s]
                }
            end
        end

        def self.is_display_mode?(snippet)
            snippet.start_with?("\\[") or snippet.start_with?("$$")
        end

        def self.split_snippet(snippet)
            displayMode = false
            range = 2..-3

            if snippet.start_with?("\\[") or snippet.start_with?("$$") then
                displayMode = true
            elsif snippet.start_with?("$") then
                range = 1..-2
            end

            [snippet[range], displayMode]
        end
    end
end