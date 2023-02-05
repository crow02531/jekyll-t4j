# frozen_string_literal: true

module Jekyll
    module Tags
        class TexSnippetBlock < Liquid::Block
            def initialize(tag_name, pkgs, tokens)
                super

                @packages = pkgs
            end

            def render(context)
                src = super

                src.prepend "\\documentclass{article}", "\\usepackage{#{@packages}}", "\\begin{document}"
                src << "\\end{document}"

                result = Jekyll::T4J::Engine.choose(src).new.convert(src)
                Jekyll::Merger.request(context.registers[:page][:url], result[:head], result[:external])
                result[:body]
            end
        end
    end
end

Liquid::Template.register_tag("tex_snippet", Jekyll::Tags::TexSnippetBlock)