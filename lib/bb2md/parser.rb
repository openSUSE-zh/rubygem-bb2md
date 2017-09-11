module BB2MD
  class Parser
    def initialize(text)
      @text = text
    end

    def parse
      BB2MD::Quote.new(@text).text
    end
  end
end
