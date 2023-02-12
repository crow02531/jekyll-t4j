# frozen_string_literal: true

require "tmpdir"
require "open3"

module Jekyll::T4J
    module Engine
        @@_dvisvgm_tex_ = File.join(__dir__, "dvisvgm.tex")

        def self.dvisvgm_raw(snippet)
            dvisvgm_raw_bulk([snippet])[0]
        end

        def self.dvisvgm_raw_bulk(snippets)
            # setup: create 'content.tex'
            pwd = Dir.mktmpdir
            File.write "#{pwd}/content.tex", <<~HEREDOC
                \\documentclass{article}
                #{Jekyll::T4J.cfg_pkgs}
                \\input{#{@@_dvisvgm_tex_}}
                \\begin{document}
                \\pagenumbering{gobble}
                \\begingroup#{snippets.join("\\endgroup\\newpage\\begingroup")}\\endgroup
                \\end{document}
            HEREDOC

            shell = ->(cmd) {
                log, s = Open3.capture2e(cmd, :chdir => pwd)
                raise log if not s.success?
            }

            # call 'latex' to compile: tex->dvi
            shell.("latex -halt-on-error -quiet content")
            shell.("latex -halt-on-error -quiet content")
            # call 'dvisvgm' to convert dvi to svg(s)
            shell.("dvisvgm -n -e -p 1- -v 3 content")

            # fetch results
            results = []
            if snippets.size == 1 then
                results << File.read("#{pwd}/content.svg")
            else
                for i in 1..snippets.size
                    results << File.read("#{pwd}/content-#{i.to_s}.svg")
                end
            end

            # return
            results
        ensure
            FileUtils.remove_entry pwd if pwd
        end
    end
end