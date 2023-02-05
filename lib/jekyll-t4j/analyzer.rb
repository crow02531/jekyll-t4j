# frozen_string_literal: true

require "strscan"

module Jekyll
    module T4J
        class Analyzer
            def initialize(sample)
                s = @sample = sample.gsub(/(?<!\\)%.*/, "")

                i = s.index(/(?<!\\)\\begin{\s*document\s*}/)
                (@preamble = s[0..i]).freeze
                (@body = s[i..-1]).freeze
            end

            attr_reader :preamble, :body

            def packages
                return @packages if @packages

                s = StringScanner.new preamble
                a = @packages = []

                s.captures[0].split(",") {|p|
                    p.strip!
                    a << p.downcase!.freeze unless p.empty?
                } while s.scan_until(/(?<!\\)\\usepackage(?:\[\w*\])?{([\w\s,]+)}/)

                a.freeze
            end

            def graph_oriented?
                # TODO
            end

            def suitable_engine
                return T4J::Dvisvgm if graph_oriented?
                return T4J::LatexJS if (packages - LatexJS::SUPPORTED_PACKAGES).empty?

                T4J::TeX4ht
            end
        end
    end
end