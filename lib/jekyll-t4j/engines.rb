# frozen_string_literal: true

module Jekyll::T4J
    module Engines
        @@_passed = nil

        def self.has_tex?
            if @@_passed == nil then
                @@_passed = system("latex -version", [:out, :err]=>File::NULL) ? true : false
            end

            @@_passed
        end

        def self.check_tex
            unless has_tex?
                STDERR.puts "You are missing a TeX distribution. Please install:"
                STDERR.puts "  MiKTeX or TeX Live"
                raise Errors::FatalException.new("Missing TeX distribution")
            end
        end
    end
end

require "jekyll-t4j/engines/dvisvgm"