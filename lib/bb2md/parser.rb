module BB2MD
  class Parser
    def initialize(text, id)
      @text = text
      @id = id
    end

    def parse
      @text = BB2MD::Quote.new(@text, @id).text
      @text = BB2MD::Code.new(@text, @id).text
      @text = BB2MD::URL.new(@text, @id).text
      @text = BB2MD::Image.new(@text, @id).text
    end
  end
end
