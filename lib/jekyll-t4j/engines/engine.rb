# frozen_string_literal: true

module Jekyll
    module T4J
        class Engine

            @@passed = nil

            # Check if there is a tex distribution in the computer.
            #
            # @return [Boolean] true or false
            def self.has_tex?
                if @@passed == nil then
                    @@passed = system("latex -version", [:out, :err]=>File::NULL) ? true : false
                end

                @@passed
            end

            # This method will raise an exception and put warnings to stderr
            # if there isn't a tex distribution.
            def self.check_tex
                unless has_tex?
                    STDERR.puts "You are missing a TeX distribution. Please install:"
                    STDERR.puts "  MiKTeX or TeX Live"
                    raise Errors::FatalException.new("Missing TeX distribution")
                end
            end

            @@rnd_range = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ$@".chars

            def self.rndname
                @@rnd_range.sample(22).join.prepend "_"
            end
        end
    end
end