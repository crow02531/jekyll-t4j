# frozen_string_literal: true

require "strscan"

module Jekyll
    module TexConverter
        class Engine

            # Choose a suitable Engine based on the given sample.
            #
            # @param [String] sample a latex document
            # @return [Class] a subclass of Engine, never be nil
            def self.choose(sample)
                pkgs = packages_in sample

                if (pkgs - LatexJS::SUPPORTED_PACKAGES).empty? then
                    return TexConverter::LatexJS
                end

                TexConverter::TexDist
            end

            def self.packages_in(sample)
                s = StringScanner.new sample.gsub(/(?<!\\)%.*/, "")
                ret = []

                s.captures[0].split(",") {|p|
                    p.strip!
                    ret << p.downcase! unless p.empty?
                } while s.scan_until(/(?<!\\)\\usepackage(?:\[\w*\])?{([\w\s,]+)}/)

                ret
            end
        end
    end
end