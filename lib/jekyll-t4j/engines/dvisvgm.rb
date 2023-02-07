# frozen_string_literal: true

require "tmpdir"

module Jekyll::T4J
    module Engines
        @@cache = {}

        def self.dvisvgm(src)
            ret = @@cache[src]
            return ret if ret

            # setup.
            check_tex
            pwd = Dir.mktmpdir
            File.write "#{pwd}/content.tex", src

            # call 'dvilualatex' to get dvi file.
            system "latex -halt-on-error content.tex", :chdir => pwd, [:out, :err] => File::NULL, exception: true
            system "latex -halt-on-error content.tex", :chdir => pwd, [:out, :err] => File::NULL, exception: true
            # call 'dvisvgm' to convert dvi to svg.
            system "dvisvgm content.dvi", :chdir => pwd, [:out, :err] => File::NULL, exception: true

            # fetch result.
            ret = File.read "#{pwd}/content.svg"
            @@cache[src] = ret
        ensure
            FileUtils.remove_entry pwd if pwd
        end
    end
end