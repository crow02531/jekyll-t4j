# frozen_string_literal: true

require "strscan"
require "cgi"

module Jekyll::T4J
    HTML_TEXT_MASK = Regexp.union(
        %r{\s*<head[\s\S]*?</head>\s*},
        %r{\s*<script[\s\S]*?</script>\s*},
        %r{\s*<style[\s\S]*?</style>\s*},
        %r{\s*<svg[\s\S]*?</svg>\s*},
        /\s*<!--.*?-->\s*/,
        /\s*<.*?>\s*/
    ).freeze

    TEXT_TEX_MASK = Regexp.union(
        /\\\[([\s\S]*?)\\\]/,
        /\$\$([\s\S]*?)\$\$/,
        /\\\(([\s\S]*?)\\\)/,
        /\$([\s\S]*?)\$/
    ).freeze

    def self.mask(str, reg, capture = false)
        s = StringScanner.new str
        parts = []

        while not s.eos? do
            p0 = s.charpos
            m = s.scan_until(reg)

            if m then
                p1 = s.charpos - s.matched.size - 1

                parts << [str[p0..p1], true] unless p1 < p0
                parts << (capture ? [s.matched, false, s.captures] : [s.matched, false])
            else
                parts << [str[p0..-1], true]
                break
            end
        end

        parts
    end
end

Jekyll::Hooks.register :documents, :post_render do |doc|
    engine = Jekyll::T4J::Engine.new(->(f, e) {Jekyll::T4J::Merger.ask_for_merge(doc.url, f, e)})
    result = String.new

    for p0 in Jekyll::T4J.mask(doc.output, Jekyll::T4J::HTML_TEXT_MASK)
        if p0[1] then
            for p1 in Jekyll::T4J.mask(p0[0], Jekyll::T4J::TEXT_TEX_MASK, true)
                if not p1[1] then
                    for i in 0..3
                        c = p1[2][i]
                        if not c.empty? then
                            p1[0] = engine.render(CGI::unescapeHTML(c), i < 2)
                            break
                        end
                    end
                end

                result << p1[0]
            end
        else
            result << p0[0]
        end
    end

    doc.output = result.insert(result.index("</head>"), engine.header)
end