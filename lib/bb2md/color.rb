module BB2MD
  class Color
    attr_reader :text
    def initialize(text)
      @text = parse(text) || text
    end

    private

    def parse(text)
      regex = /\[color=.*?:(.*?)\](.*?)\[\/color.*?\]/m
      return unless text =~ regex
      colors = text.scan(regex)
      colors.each do |c|
        text.gsub!(/\[color=.*?:#{c[0]}\]#{Regexp.escape(c[1])}\[\/color:#{c[0]}\]/, c[1])
      end
      text
    end
  end
end
