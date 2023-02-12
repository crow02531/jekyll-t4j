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
        /\\\[[\s\S]*?\\\]/,
        /\$\$[\s\S]*?\$\$/,
        /\\\([\s\S]*?\\\)/,
        /\$[\s\S]*?\$/
    ).freeze

    def self.mask(str, reg)
        s = StringScanner.new str
        parts = []

        while not s.eos? do
            p0 = s.charpos
            m = s.scan_until(reg)

            if m then
                p1 = s.charpos - s.matched.size - 1

                parts << [str[p0..p1], true] unless p1 < p0
                parts << [s.matched, false]
            else
                parts << [str[p0..-1], true]
                break
            end
        end

        parts
    end

    def self.extract(html)
        result = []
        prev = nil

        for p0 in Jekyll::T4J.mask(html, Jekyll::T4J::HTML_TEXT_MASK)
            if p0[1] then #p0[0] is a text node
                for p1 in Jekyll::T4J.mask(p0[0], Jekyll::T4J::TEXT_TEX_MASK)
                    if not p1[1] then #p1[0] is a tex snippet
                        prev = nil
                        p1[1] = true
                        result << p1
                    else
                        if prev then
                            prev << p1[0]
                        else
                            prev = p1[0]
                            p1[1] = false
                            result << p1
                        end
                    end
                end
            else
                if prev then
                    prev << p0[0]
                else
                    prev = p0[0]
                    result << p0
                end
            end
        end

        result
    end
end

Jekyll::Hooks.register :documents, :post_render do |doc|
    engine = Jekyll::T4J::Engine.new(->(f, e) {Jekyll::T4J::Merger.ask_for_merge(doc.url, f, e)})
    result = String.new

    for p in Jekyll::T4J.extract(doc.output)
        if p[1] then #p[0] is a tex snippet
            result << engine.render(CGI::unescapeHTML(p[0])) #TODO: a very subtle bug
        else
            result << p[0]
        end
    end

    doc.output = result.insert(result.index("</head>"), engine.header)
end