# frozen_string_literal: true

require "tmpdir"

module Jekyll
    module T4J
        class TeX4ht < Engine

            def initialize
                Engine.check_tex
            end

            def convert(src)
                # setup.
                pwd = Dir.mktmpdir
                File.write "#{pwd}/content.tex", src

                # call `make4ht` build system.
                system "make4ht -lm draft -e #{TexConverter::ROOT}/script/build-file.lua content.tex \"fancylogo\"", :chdir => pwd, [:out, :err] => File::NULL, exception: true

                # fetch result.
                body = File.read "#{pwd}/content.html"
                css_name = Engine.rndname << ".css"
                head = "<link rel=\"stylesheet\" href=\"#{css_name}\">"
                external = {css_name => File.read("#{pwd}/content.css")}
                Dir.glob("#{pwd}/*.svg").each {|p| external[File.basename p] = File.read p}

                # return.
                {head:, body:, external:}
            ensure
                FileUtils.remove_entry pwd
            end
        end
    end
end