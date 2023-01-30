require "tmpdir"

module Jekyll
    module TexConverter
        class TexDist

            def setup(input)
                unlink if @pwd
                @pwd = Dir.mktmpdir
                File.write "#{@pwd}/content.tex", input
            end

            def compile(mode)
                # call `make4ht` build system.
                system "make4ht -m draft -e #{TexConverter::ROOT}/script/build-#{mode}.lua content.tex", :chdir=>@pwd, [:out, :err]=>File::NULL, exception: true

                # fetch result.
                body = File.read "#{@pwd}/content.html"
                if(mode == "normal")
                    head = "<link rel=\"stylesheet\" href=\"content.css\">"
                    external = {}

                    Dir.glob("#{@pwd}/*.{svg,css}").each { |path|
                        external[File.basename path] = File.read path
                    }
                    external = external.freeze

                    @result = {body:, head:, external:}
                else
                    head = "<style>#{File.read "#{@pwd}/content.css"}</style>"
                    @result = {body:, head:}
                end

                # freeze the result
                @result = @result.freeze
            end

            def output
                @result
            end

            def unlink
                FileUtils.remove_entry @pwd
                @pwd = nil
                @result = nil
            end
        end
    end
end