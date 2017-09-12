module BB2MD
  class Parser
    def initialize(text)
      @text = text
    end

    def parse
      @text = BB2MD::Quote.new(@text).text
      @text = BB2MD::Code.new(@text).text
      @text = BB2MD::URL.new(@text).text
      @text = BB2MD::Image.new(@text).text
      @text = BB2MD::Color.new(@text).text
      @text = BB2MD::Size.new(@text).text
    end
  end
end
