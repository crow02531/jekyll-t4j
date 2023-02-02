require "tmpdir"

module Jekyll
    module TexConverter
        class TexDist < Engine

            @@passed = "unknown"

            def self.has_env
                @@passed = system "make4ht -v", [:out, :err]=>File::NULL if @@passed == "unknown"
                @@passed
            end

            def self.check_env
                unless has_env
                    STDERR.puts "You are missing a TeX distribution. Please install:"
                    STDERR.puts "  MiKTeX or TeX Live"
                    raise Errors::FatalException.new("Missing TeX distribution")
                end
            end

            def setup(input)
                TexDist.check_env
                unlink
                @pwd = Dir.mktmpdir
                File.write "#{@pwd}/content.tex", input
            end

            def compile
                # call `make4ht` build system.
                system "make4ht -m draft -e #{TexConverter::ROOT}/script/build-file.lua content.tex", :chdir=>@pwd, [:out, :err]=>File::NULL, exception: true

                # fetch result.
                body = File.read "#{@pwd}/content.html"
                head = ""
                external = {}

                Dir.glob("#{@pwd}/*.{svg,css}").each {|path|
                    external[File.basename path] = File.read path
                    head = "<link rel=\"stylesheet\" href=\"#{File.basename path}\">" if path.end_with? "css"
                }

                external = external.freeze
                @result = {body:, head:, external:}.freeze
            end

            def output
                @result
            end

            def unlink
                FileUtils.remove_entry @pwd if @pwd
                @pwd = nil
                @result = nil
            end
        end
    end
end