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
      @text = BB2MD::Style.color("color", @text, "")
      @text = BB2MD::Style.size("size", @text, "")
      @text = BB2MD::Style.bold("b", @text, "**")
      @text = BB2MD::Style.italic("i", @text, "*")
      @text = BB2MD::Style.underline("u", @text, "__")
      @text = BB2MD::Style.strike("s", @text, "~~")
    end
  end
end
