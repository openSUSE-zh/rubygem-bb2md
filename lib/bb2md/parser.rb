module BB2MD
  class Parser
    def initialize(text)
      @text = text
    end

    def parse
      @text = BB2MD::Quote.new(@text).text || @text
      @text = BB2MD::Code.new(@text).text || @text
    end
  end
end
