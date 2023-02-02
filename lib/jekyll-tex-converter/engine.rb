module Jekyll
    module TexConverter
        class Engine

            # Choose a suitable Engine based on the given sample.
            #
            # @param [String] sample a latex document
            # @return [Class] a subclass of Engine, never be nil
            def self.choose(sample)
                TexConverter::TexDist
            end
        end
    end
end