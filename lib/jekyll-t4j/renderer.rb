# frozen_string_literal: true

require "strscan"

module Jekyll::T4J
    HTML_TEXT_MASK = Regexp.union(
        %r{\s*<head[\s\S]*?</head>\s*},
        %r{\s*<script[\s\S]*?</script>\s*},
        %r{\s*<style[\s\S]*?</style>\s*},
        %r{\s*<svg[\s\S]*?</svg>\s*},
        /\s*<!--.*?-->\s*/,
        /\s*<.*?>\s*/
    ).freeze

    def self.mask(str, reg)
        s = StringScanner.new str
        parts = []

        while not s.eos? do
            p0 = s.charpos
            m = s.scan_until(reg)

            if m then
                p1 = s.charpos - s.matched.size - 1

                parts << [str[p0..p1], true] unless p1 <= p0
                parts << [s.matched, false]
            else
                parts << [str[p0..-1], true]
                break
            end
        end

        parts
    end
end

Jekyll::Hooks.register :documents, :post_render do |doc|
    parts = Jekyll::T4J.mask(doc.output, Jekyll::T4J::HTML_TEXT_MASK)
    result = String.new

    gen = -> (s, m) {
        s.prepend "\\documentclass{article}#{Jekyll::T4J.cfg_pkgs}\\begin{document}\\pagenumbering{gobble}"
        s << "\\end{document}"
        "<img src=\"#{Jekyll::T4J::Merger.ask_for_merge(doc.url, Jekyll::T4J::Engines.dvisvgm(s), "svg")}\" style=\"#{m ? "display: inline;" : "display: block;margin: 0 auto"}\">"
    }

    for p in parts
        if p[1] then
            # TODO: escape
            p[0].gsub!(/\$\$[\s\S]+?\$\$/) {|m| gen.(m, false)}
            p[0].gsub!(/\\\[([\s\S]+?)\\\]/) {gen.("$$#{$1}$$", false)}
            p[0].gsub!(/\\begin{displaymath}([\s\S]+?)\\end{displaymath}/) {gen.("$$#{$1}$$", false)}
            p[0].gsub!(/\\begin{equation}([\s\S]+?)\\end{equation}/) {gen.("$$#{$1}$$", false)}

            p[0].gsub!(/\$[\s\S]+?\$/) {|m| gen.(m, true)}
            p[0].gsub!(/\\\(([\s\S]+?)\\\)/) {gen.("$#{$1}$", true)}
            p[0].gsub!(/\\begin{math}([\s\S]+?)\\end{math}/) {gen.("$#{$1}$", true)}
        end

        result << p[0]
    end

    doc.output = result
end