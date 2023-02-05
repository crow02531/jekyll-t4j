# frozen_string_literal: true

module Jekyll
    module Merger
        @@available = true
        @@dest = nil
        @@cache = {}

        def self.request(url, head, external)
            raise "Merge request during post processing!" unless @@available

            request = @@cache[url]
            exists = request != nil
            request = {} if not exists

            if head and !head.empty? then
                head.freeze

                if r = request[:head] then
                    r << head
                else
                    request[:head] = [head]
                end
            end

            if external and !external.empty? then
                external.each {|k, v| k.freeze; v.freeze}

                if r = request[:external] then
                    r.merge!(external)
                else
                    request[:external] = Hash.new(external)
                end
            end

            @@cache[url] = request if not exists and !request.empty?
        end

        # get destination folder
        Jekyll::Hooks.register :site, :after_init do |site|
            @@dest = site.dest
        end

        # insert code into html
        Jekyll::Hooks.register :documents, :post_render do |doc|
            @@available = false

            request = @@cache[doc.url]
            if request then
                r = request[:head]
                doc.output.insert(doc.output.index("<head>") + 6, r.uniq!.join) if r
            end
        end

        # write external files
        Jekyll::Hooks.register :documents, :post_write do |doc|
            url = doc.url
            request = @@cache[url]

            if request then
                if r = request[:external] then
                    url = File.dirname url unless url.end_with? "/"

                    r.each {|k, v|
                        File.write File.join(@@dest, url, k), v
                    }
                end
            end
        end

        # clean up
        Jekyll::Hooks.register :site, :post_write do
            @@cache.clear
            @@available = true
        end
    end
end