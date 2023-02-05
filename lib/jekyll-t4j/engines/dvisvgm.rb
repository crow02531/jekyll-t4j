# frozen_string_literal: true

module Jekyll
    module T4J
        class Dvisvgm < Engine
            def self.compile(analyzer)
                Engine.check_tex

                # setup.
                pwd = Dir.mktmpdir
                f = File.open "#{pwd}/content.tex"
                f.write analyzer.preamble
                f.write "\\pagenumbering{gobble}" # disable page numbering
                f.write analyzer.body
                f.close

                # call 'dvilualatex' to get dvi file.
                system "dvilualatex --draftmode --halt-on-error content.tex", :chdir => pwd, [:out, :err] => File::NULL, exception: true
                # call 'dvisvgm' to convert dvi to svg.
                system "dvisvgm --bbox=min content.dvi", :chdir => pwd, [:out, :err] => File::NULL, exception: true

                # fetch result.
                f = Engine.rndname << ".svg"
                body = "<img src=\"#{f}\">"
                external = {f => File.read("#{pwd}/content.svg")}

                # return.
                {body:, external:}
            ensure
                FileUtils.remove_entry pwd
            end
        end
    end
end