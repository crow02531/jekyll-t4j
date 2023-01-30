module Jekyll
    module Converters
        class Tex < Converter
            EXTENSION_PATTERN = /^\.tex$/i.freeze

            # called by Jekyll system
            def initialize(config = {})
                super

                @cache = {}
                @@instance = self
            end

            def self.instance
                @@instance
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

            Jekyll::Hooks.register :site, :post_write do
                Jekyll::Converters::Tex.instance.post_generation
            end

            def matches(ext)
                ext =~ EXTENSION_PATTERN
            end

            def output_ext(ext)
                ".html"
            end

            def self.should_inline?(doc)
                !doc.url.end_with? "/"
            end

            def should_inline?
                Tex.should_inline?(@processing)
            end

            def pre_convert(doc)
                @processing = doc
            end

            def convert(content)
                dist = Jekyll::TexConverter::TexDist.new

                dist.setup(content)
                dist.compile(should_inline? ? "inline" : "normal")
                (@cache[@processing.url] = dist.output)[:body]
            ensure
                dist.unlink
            end

            def post_convert
                doc = @processing
                doc.output = doc.output.insert(doc.output.index("<head>") + 6, (@cache[doc.url])[:head])
                @processing = nil
            end

            def post_write(doc)
                return if Tex.should_inline? doc

                (@cache[doc.url])[:external].each { |k, v|
                    File.write File.join("_site", doc.url, k), v
                }
            end

            def post_generation
                @cache.clear
            end
        end
    end
end