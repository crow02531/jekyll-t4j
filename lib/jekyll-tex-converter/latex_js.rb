# frozen_string_literal: true

module Jekyll
    module TexConverter
        class LatexJS < Engine
            SUPPORTED_PACKAGES = [
                "color",
                "xcolor",
                "echo",
                "gensymb",
                "graphics",
                "graphicx",
                "hyperref",
                "latexsym",
                "multicol",
                "stix",
                "textcomp",
                "textgreek",
                "comment",
                "calc",
                "pict2e",
                "picture",
                "babel",
                "fontspec",
                "ctex",
                "cjk",
            ].freeze

            def setup(input)
                @input = input
                @result = nil
            end

            def compile
                
            end

            def output
                @result
            end

            def unlink
                @input = nil
                @result = nil
            end
        end
    end
end