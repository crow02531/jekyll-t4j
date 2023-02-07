# frozen_string_literal: true

require "strscan"

module Jekyll::T4J
    def self.mask(str, reg)
        s = StringScanner.new str
        parts = []

        while not s.eos? do
            p = s.charpos
            m = s.scan_until(reg)

            if m then
                parts << [str[p..(s.charpos - s.matched.size - 1)], true] unless s.charpos == s.matched.size
                parts << [s.matched, false]
            else
                parts << [str[p..-1], true]
                break
            end
        end

        parts
    end
end

Jekyll::Hooks.register :documents, :post_render do |doc|
    parts = Jekyll::T4J.mask(doc.output, %r{<script[\s\S]*?</script>|<style[\s\S]*?</style>|<svg[\s\S]*?</svg>|<!--.*?-->|<.*?>})
    result = String.new

    gen = -> (s, m) {
        s.prepend "\\documentclass{article}\\begin{document}\\pagenumbering{gobble}"
        s << "\\end{document}"
        "<img src=\"#{Jekyll::T4J::Merger.ask_for_merge(doc.url, Jekyll::T4J::Engines.dvisvgm(s), "svg")}\" style=\"#{m ? "display: inline;" : "display: block;margin: 0 auto"}\">"
    }

    for p in parts
        if p[1] then
            p[0].gsub!(/(?<!\\)\$\$[\s\S]+?(?<!\\)\$\$/) {|m| gen.(m, false)}
            p[0].gsub!(/(?<!\\)\\\[([\s\S]+?)(?<!\\)\\\]/) {gen.("$$#{$1}$$", false)}
            p[0].gsub!(/(?<!\\)\\begin{displaymath}([\s\S]+?)(?<!\\)\\end{displaymath}/) {gen.("$$#{$1}$$", false)}
            p[0].gsub!(/(?<!\\)\\begin{equation}([\s\S]+?)(?<!\\)\\end{equation}/) {gen.("$$#{$1}$$", false)}

            p[0].gsub!(/(?<!\\)\$[\s\S]+?(?<!\\)\$/) {|m| gen.(m, true)}
            p[0].gsub!(/(?<!\\)\\\(([\s\S]+?)(?<!\\)\\\)/) {gen.("$#{$1}$", true)}
            p[0].gsub!(/(?<!\\)\\begin{math}([\s\S]+?)(?<!\\)\\end{math}/) {gen.("$#{$1}$", true)}
        end

        result << p[0]
    end

    doc.output = result
end