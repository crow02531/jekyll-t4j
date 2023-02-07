# frozen_string_literal: true

module Jekyll::T4J
    module Merger
        @@available = true
        @@dest = nil
        @@cache = {}
        @@rnd_range = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ$@".chars
    
        def self.ask_for_merge(url, filedata, extname)
            raise "Merge request during post processing!" unless @@available

            request = @@cache[url]
            request = @@cache[url] = {} unless request

            entry = request.rassoc(filedata.freeze)
            return entry[0] if entry and entry[0].split(".")[1] == extname

            filename = @@rnd_range.sample(22).join.prepend("_") << "." << extname
            request[filename] = filedata
            filename.freeze
        end

        # get destination folder
        Jekyll::Hooks.register :site, :after_init do |site|
            @@dest = site.dest
        end

        # write external files
        Jekyll::Hooks.register :documents, :post_write do |doc|
            url = doc.url
            request = @@cache[url]

            if request then
                url = File.dirname url unless url.end_with? "/"

                request.each {|k, v|
                    File.write File.join(@@dest, url, k), v
                }

                request.clear
            end
        end

        # clean up
        Jekyll::Hooks.register :site, :post_write do
            @@cache.clear
            @@available = true
        end
    end
end