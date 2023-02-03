# frozen_string_literal: true

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

            def pre_convert(doc)
                @processing = doc
            end

            def convert(content)
                engine = Jekyll::TexConverter::Engine.choose(content).new

                engine.setup(content)
                engine.compile
                (@cache[@processing.url] = engine.output)[:body]
            ensure
                engine.unlink
            end

            def post_convert
                doc = @processing
                doc.output = doc.output.insert(doc.output.index("<head>") + 6, (@cache[doc.url])[:head])
                @processing = nil
            end

            def post_write(doc)
                url = doc.url
                url = File.dirname url unless url.end_with? "/"

                (@cache[doc.url])[:external].each {|k, v|
                    File.write File.join("_site", url, k), v
                }
            end

            def post_generation
                @cache.clear
            end
        end
    end
end