module Jekyll
    module Converters
        class Tex < Converter
            EXTENSION_PATTERN = /^\.tex$/i.freeze

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
                ext =~ EXTENSION_PATTERN
            end

            def output_ext(ext)
                ".html"
            end

            # merge css
            Jekyll::Hooks.register :documents, :post_render do |doc|
                return unless doc.extname =~ EXTENSION_PATTERN
                src = doc.output

                # inline css
                doc.output = src.insert(src.index("<head>") + 6, "<style>" + File.read(".tex-cache/content.css") + "</style>")
            end

            def convert(content)
                setup

                # write content to 'content.tex'.
                File.open(".tex-cache/content.tex", "w") {|f| f.write(content)}

                # call `make4ht` build system.
                system("make4ht -m draft -e #{Jekyll::TexConverter::ROOT}/script/build-file.lua content.tex", :chdir=>".tex-cache", [:out, :err]=>File::NULL, exception: true)

                # fetch content from 'content.html'.
                File.read(".tex-cache/content.html")
            end
        end
    end
end