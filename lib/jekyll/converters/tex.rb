module Jekyll
    module Converters
        class Tex < Converter
            def setup
                return if @setup

                # check if there is a TeX distribution.
                unless system("make4ht -v")
                    STDERR.puts "You are missing TeX distribution. Please install:"
                    STDERR.puts "  MiKTeX or TeX Live"
                    raise Errors::FatalException.new("Missing TeX distribution")
                end

                # create the '.tex-cache' directory.
                Dir.mkdir(".tex-cache") unless File.exist?(".tex-cache")

                @setup = true
            end

            def matches(ext)
                ext =~ /^\.tex$/i
            end

            def output_ext(ext)
                ".html"
            end

            def convert(content)
                setup

                # write content to 'page.tex'.
                File.open(".tex-cache/page.tex", "w") {|f| f.write(content)}

                # call `make4ht`.
                system("make4ht -m draft -e #{Jekyll::TexConverter::ROOT}/script/build-file.lua page.tex \"-css,no-DOCTYPE\"", :chdir=>".tex-cache", [:out, :err]=>File::NULL, exception: true)

                # fetch content from 'page.html'.
                File.read(".tex-cache/page.html")
            end
        end
    end
end