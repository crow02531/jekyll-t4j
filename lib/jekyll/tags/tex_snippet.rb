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

                analyzer = Jekyll::T4J::Analyzer.new src
                result = analyzer.suitable_engine.compile(analyzer)

                Jekyll::Merger.request(context.registers[:page][:url], result[:head], result[:external])
                result[:body]
            end
        end
    end
end

Liquid::Template.register_tag("tex_snippet", Jekyll::Tags::TexSnippetBlock)