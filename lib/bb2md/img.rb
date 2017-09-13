module BB2MD
  # Parse the URLs
  class Image
    attr_reader :text
    def initialize(text)
      @text = parse(text) || text
    end

    private

    def parse(text)
      regex = %r{\[img:(.*?)\](.*?)\[/img:.*?\]}m
      return unless text =~ regex
      imgs = text.scan(regex)
      imgs.each do |i|
        text.gsub!("[img:#{i[0]}]#{Regexp.escape(i[1])}[/img:#{i[0]}]",
                   "\n![](#{i[1]})\n")
      end
      text
    end
  end
end
