# frozen_string_literal: true

module Jekyll
    module Converters
        class Tex < Converter
            EXTENSION_PATTERN = /^\.tex$/i.freeze

            def initialize(config = {})
                super

                @@instance = self
            end

            def self.instance
                @@instance
            end

            # disable excerpt for '.tex'
            Jekyll::Hooks.register :documents, :post_init do |doc|
                doc.data["excerpt_separator"] = "" if doc.extname =~ EXTENSION_PATTERN
            end

            Jekyll::Hooks.register :documents, :pre_render do |doc|
                Jekyll::Converters::Tex.instance.pre_convert(doc) if doc.extname =~ EXTENSION_PATTERN
            end

            def matches(ext)
                ext =~ EXTENSION_PATTERN
            end

            def output_ext(ext)
                ".html"
            end

            def pre_convert(doc)
                @processing_url = doc.url
            end

            def convert(content)
                result = Jekyll::T4J::Engine.choose(content).new.convert(content)

                Jekyll::Merger.request(@processing_url, result[:head], result[:external])
                @processing_url = nil
                result[:body]
            end
        end
    end
end