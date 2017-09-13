module BB2MD
  # Parse the images
  class Image
    attr_reader :text
    def initialize(text, id)
      @text = parse(text, id)
    end

    private

    def parse(text, id)
      regex = %r{\[img:#{id}\](.*?)\[/img:#{id}\]}m
      return text unless text =~ regex
      imgs = text.scan(regex)
      imgs.map! { |i| i[0] }
      imgs.each do |i|
        text.gsub!("[img:#{id}]#{i}[/img:#{id}]",
                   "\n![](#{i})\n")
      end
      text
    end
  end
end
