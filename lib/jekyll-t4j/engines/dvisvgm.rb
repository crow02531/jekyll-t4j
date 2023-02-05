# frozen_string_literal: true

module Jekyll
    module T4J
        class Dvisvgm < Engine

            def initialize
                Engine.check_tex
            end

            def convert(src)
                # setup.
                pwd = Dir.mktmpdir
                File.write "#{pwd}/content.tex", src

                # call 'dvilualatex' to get dvi file.
                system "dvilualatex --draftmode --halt-on-error content.tex", :chdir => pwd, [:out, :err] => File::NULL, exception: true
                # call 'dvisvgm' to convert dvi to svg.
                system "dvisvgm --bbox=min content.dvi", :chdir => pwd, [:out, :err] => File::NULL, exception: true

                # fetch result.
                filename = Engine.rndname << ".svg"
                body = "<img src=\"#{filename}\">"
                external = {filename => File.read("#{pwd}/content.svg")}

                # return.
                {body:, external:}
            ensure
                FileUtils.remove_entry pwd
            end
        end
    end
end