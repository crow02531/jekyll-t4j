module Jekyll
    module Converters
        class Tex < Converter
            EXTENSION_PATTERN = /^\.tex$/i.freeze

            @@instance = nil

            def self.setup(instance)
                return if @@instance

                # check if there is a TeX distribution.
                unless system("make4ht -v", [:out, :err]=>File::NULL)
                    STDERR.puts "You are missing TeX distribution. Please install:"
                    STDERR.puts "  MiKTeX or TeX Live"
                    raise Errors::FatalException.new("Missing TeX distribution")
                end

                # clean the '.tex-cache' directory.
                TexConverter.cache_clean()

                @@instance = instance
            end

            def self.instance
                @@instance
            end

            def matches(ext)
                ext =~ EXTENSION_PATTERN
            end

            def output_ext(ext)
                ".html"
            end

            Jekyll::Hooks.register :site, :after_init do |site|
                Jekyll::Converters::Tex.setup(site.find_converter_instance Jekyll::Converters::Tex)
            end

            Jekyll::Hooks.register :documents, :pre_render do |doc|
                Jekyll::Converters::Tex.instance.pre_convert(doc) if doc.extname =~ EXTENSION_PATTERN
            end

            Jekyll::Hooks.register :documents, :post_render do |doc|
                Jekyll::Converters::Tex.instance.post_convert if doc.extname =~ EXTENSION_PATTERN
            end

            Jekyll::Hooks.register :documents, :post_write do |doc|
                Jekyll::Converters::Tex.instance.post_write(doc) if doc.extname =~ EXTENSION_PATTERN
            end

            def should_inline?
                !@processing.url.end_with? "/"
            end

            def cache_dir
                s = @processing.url
                s += ".html/" unless s.end_with? "/"
                File.join TexConverter::CACHE_ROOT, s
            end

            def pre_convert(doc)
                @processing = doc
            end

            def convert(content)
                pwd = cache_dir

                # write content to 'content.tex'.
                FileUtils.mkdir_p pwd
                File.open("#{pwd}content.tex", "w") {|f| f.write(content)}

                # call `make4ht` build system.
                system("make4ht -m draft -e #{TexConverter::ROOT}/script/build-#{should_inline? ? "inline" : "normal"}.lua content.tex", :chdir=>pwd, [:out, :err]=>File::NULL, exception: true)

                # fetch result from 'content.html'.
                File.read("#{pwd}content.html")
            end

            # tweak the final rendering result
            def post_convert
                s = ""

                if should_inline?
                    s = "<style>#{File.read("#{cache_dir}content.css")}</style>"
                else
                    s = "<link rel=\"stylesheet\" href=\"content.css\">"
                end

                @processing.output = @processing.output.insert(@processing.output.index("<head>") + 6, s)
                @processing = nil
            end

            # move corresponding cache files to 'doc.url'
            def post_write(doc)
                @processing = doc
                FileUtils.mv Dir.glob("#{cache_dir}*.{svg,css}"), File.join("_site", doc.url) unless should_inline?
                @processing = nil
            end
        end
    end
end