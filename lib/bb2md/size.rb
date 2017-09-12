module BB2MD
  class Size
    attr_reader :text
    def initialize(text)
      @text = parse(text) || text
    end

    private

    def parse(text)
      regex = /\[size=.*?:(.*?)\](.*?)\[\/size.*?\]/m
      return unless text =~ regex
      sizes = text.scan(regex)
      sizes.each do |s|
        text.gsub!(/\[size=.*?:#{s[0]}\]#{Regexp.escape(s[1])}\[\/size:#{s[0]}\]/, s[1])
      end
      text
    end
  end
end
