# frozen_string_literal: true

module Jekyll
    module T4J
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

            def convert(src)
                filename = Engine.rndname << ".tex"
                head = "<script src=\"https://unpkg.com/latex.js@#{VERSION}/dist/latex.js\"></script>"
                body = <<~HEREDOC
                    <script id="#{filename}">
                        fetch("#{filename}")
                        .then(response => response.text())
                        .then(tex => {
                            let gen = latexjs.parse(tex, { generator: new latexjs.HtmlGenerator() })

                            document.head.appendChild(gen.stylesAndScripts("https://unpkg.com/latex.js@#{VERSION}/dist/"))
                            document.getElementById("#{filename}").replaceWith(gen.domFragment())
                        })
                    </script>
                HEREDOC

                {head:, body:, :external => {filename => src}}
            end
        end
    end
end