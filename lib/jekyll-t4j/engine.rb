# frozen_string_literal: true

unless system("latex -version", [:out, :err] => File::NULL)
    STDERR.puts "You are missing a TeX distribution. Please install:"
    STDERR.puts "  MiKTeX or TeX Live or..."
    raise "Missing TeX distribution"
end

require "open3"

require "jekyll-t4j/engine/dvisvgm"
require "jekyll-t4j/engine/katex"

module Jekyll::T4J
    module Engine
        @@cache_katex = Jekyll::Cache.new "Jekyll::T4J::Katex"
        @@cache_dvisvgm = Jekyll::Cache.new "Jekyll::T4J::Dvisvgm"

        HEADER = <<~HD
            <link rel=\"stylesheet\" href=\"https://unpkg.com/katex@#{KATEX_VERSION}/dist/katex.min.css\">
            <style>
                .katex {
                    font-size: 1em;
                }
                .katex-ext-d {
                    border-radius: 0px;
                    display: block;
                    margin: 5px auto;
                }
                .katex-ext-i {
                    border-radius: 0px;
                    display: inline;
                    vertical-align: sub;
                }
            </style>
        HD
        .freeze

        private_constant :HEADER

        def self.header
            HEADER
        end

        def self.setup
            setup_katex
            setup_dvisvgm
        end

        def self.render(snippets, merger)
            gen = ->(svgData, displayMode) {
                "<img src=\"#{merger.(svgData, ".svg")}\" class=\"#{
                    displayMode ? "katex-ext-d" : "katex-ext-i"
                }\" style=\"height:#{
                    (svgData[/height='(\S+?)pt'/, 1].to_f * 0.1).round(4)
                }em\">"
            }

            # 'snippets' << caches
            uncached = {} #act as hash set
            snippets.each_with_index do |s, i|
                r = nil

                begin
                    r = @@cache_katex[s.source]
                rescue
                    begin
                        r = gen.(@@cache_dvisvgm[Jekyll::T4J.cfg_pkgs + s.source], s.display_mode?)
                    rescue
                        uncached[s] = nil
                    end
                end

                snippets[i] = r if r
            end

            # finish if no 'uncached' found
            return if uncached.empty?
            uncached = uncached.keys

            # otherwise render 'uncached' with katex and cache them
            katex_raw_bulk(uncached).each_with_index do |result, i|
                @@cache_katex[uncached[i].source] = result if result
            end

            # 'snippets' << rendering results
            uncached = {} #act as hash set again
            snippets.each_with_index do |s, i|
                next if !s.is_a?(Snippet)

                begin
                    snippets[i] = @@cache_katex[s.source]
                rescue
                    uncached[s] = nil
                end
            end

            # finish if no 'uncached' found
            return if uncached.empty?
            uncached = uncached.keys

            # otherwise render 'uncached' with dvisvgm and cache them
            dvisvgm_raw_bulk(uncached).each_with_index do |result, i|
                @@cache_dvisvgm[Jekyll::T4J.cfg_pkgs + uncached[i].source] = result
            end

            # 'snippets' << rendering results
            snippets.each_with_index do |s, i|
                next if !s.is_a?(Snippet)

                begin
                    snippets[i] = gen.(@@cache_dvisvgm[Jekyll::T4J.cfg_pkgs + s.source], s.display_mode?)
                rescue
                    # impossible!
                end
            end
        end

        def self.shell(cmd, pwd, n = 1)
            n.times do
                log, s = Open3.capture2e(cmd, :chdir => pwd) # TODO: even the quickest 'dvisvgm' cost at least 0.3s in my laptop
                raise log if not s.success?
            end
        end
    end
end