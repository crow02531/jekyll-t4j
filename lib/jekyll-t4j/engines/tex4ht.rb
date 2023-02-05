# frozen_string_literal: true

require "tmpdir"

module Jekyll
    module T4J
        class TeX4ht < Engine
            def self.compile(analyzer)
                Engine.check_tex

                # setup.
                pwd = Dir.mktmpdir
                f = File.open "#{pwd}/content.tex"
                f.write analyzer.preamble
                f.write analyzer.body
                f.close

                # call `make4ht` build system.
                system "make4ht -lm draft -e #{TexConverter::ROOT}/script/build-file.lua content.tex \"fancylogo\"", :chdir => pwd, [:out, :err] => File::NULL, exception: true

                # fetch result.
                body = File.read "#{pwd}/content.html"
                f = Engine.rndname << ".css"
                head = "<link rel=\"stylesheet\" href=\"#{f}\">"
                external = {f => File.read("#{pwd}/content.css")}
                Dir.glob("#{pwd}/*.svg").each {|p| external[File.basename p] = File.read p}

                # return.
                {head:, body:, external:}
            ensure
                FileUtils.remove_entry pwd
            end
        end
    end
end