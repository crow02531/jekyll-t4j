# frozen_string_literal: true

require "tmpdir"

module Jekyll::T4J
    module Engines
        def self.dvisvgm(src)
            check_tex

            # setup.
            pwd = Dir.mktmpdir
            File.write "#{pwd}/content.tex", src

            # call 'dvilualatex' to get dvi file.
            system "latex -halt-on-error content.tex", :chdir => pwd, [:out, :err] => File::NULL, exception: true
            system "latex -halt-on-error content.tex", :chdir => pwd, [:out, :err] => File::NULL, exception: true
            # call 'dvisvgm' to convert dvi to svg.
            system "dvisvgm content.dvi", :chdir => pwd, [:out, :err] => File::NULL, exception: true

            # fetch result and return.
            File.read "#{pwd}/content.svg"
        ensure
            FileUtils.remove_entry pwd
        end
    end
end