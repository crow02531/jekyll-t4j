# frozen_string_literal: true

module Jekyll
    module TexConverter
        class LatexJS < Engine
            VERSION = "0.12.4"

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
                "picture"
            ].freeze

            def setup(input)
                @input = input
                @result = nil
            end

            def compile
                filename = Engine.rndname << ".tex"
                head = "<script src=\"https://unpkg.com/latex.js@#{VERSION}/dist/latex.js\"></script>"
                body = <<~HEREDOC
                    <script>
                        fetch("#{filename}")
                        .then(response => response.text())
                        .then(tex => {
                            let gen = latexjs.parse(tex, { generator: new latexjs.HtmlGenerator() })

                            document.head.appendChild(gen.stylesAndScripts("https://unpkg.com/latex.js@#{VERSION}/dist/"))
                            document.body.firstElementChild.remove()
                            document.body.appendChild(gen.domFragment())
                        })
                    </script>
                HEREDOC

                @result = {head:, body:, :external => {filename => @input}}
                freeze_result
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