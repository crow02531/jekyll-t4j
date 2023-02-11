# frozen_string_literal: true

require "tmpdir"

module Jekyll::T4J
    class Engine
        def self.dvisvgm_raw(src)
            # setup: write 'src' to 'content.tex'
            pwd = Dir.mktmpdir
            File.write "#{pwd}/content.tex", src

            # call 'latex' to compile: tex->dvi
            system "latex -halt-on-error content", :chdir => pwd, [:out, :err] => File::NULL, exception: true
            system "latex -halt-on-error content", :chdir => pwd, [:out, :err] => File::NULL, exception: true
            # call 'dvisvgm' to convert dvi to svg
            system "dvisvgm -n -e content", :chdir => pwd, [:out, :err] => File::NULL, exception: true

            # fetch result
            File.read "#{pwd}/content.svg"
        ensure
            FileUtils.remove_entry pwd if pwd
        end
    end
end