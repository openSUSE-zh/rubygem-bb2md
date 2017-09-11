module BB2MD
  class Parser
    def initialize(text)
      @text = text
    end

    def parse
      @text = BB2MD::Quote.new(@text).text
    end
  end
end

require './quote.rb'

BB2MD::Parser.new("").parse
