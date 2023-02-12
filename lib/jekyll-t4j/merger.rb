# frozen_string_literal: true

module Jekyll::T4J
    module Merger
        @@table = {}
        @@rnd_range = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ$@".chars

        def self.trim_to_dir(str)
            str.end_with?("/") ? str : (File.dirname(str) + "/")
        end

        def self.ask_for_merge(url, filedata, extname)
            url = trim_to_dir(url)
            request = @@table[url]
            request = @@table[url] = {} unless request

            entry = request.rassoc(filedata.freeze)
            return entry[0] if entry and entry[0].split(".")[1] == extname

            filename = @@rnd_range.sample(22).join.prepend("_") << "." << extname
            request[filename] = filedata
            filename.freeze
        end

        # write external files and clean up
        Jekyll::Hooks.register :site, :post_write do |site|
            site.each_site_file {|f|
                url = trim_to_dir(f.is_a?(Jekyll::StaticFile) ? f.relative_path : f.url)
                request = @@table[url]

                if request then
                    request.each {|k, v| File.write(File.join(site.dest, url, k), v)}
                    request.clear
                end
            }

            @@table.clear
        end
    end
end