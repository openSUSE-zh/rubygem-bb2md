module BB2MD
  # Parse the URLs
  class URL
    attr_reader :text
    def initialize(text, id)
      @text = parse(text, id)
      @text = parse1(@text, id)
    end

    private

    def parse(text, id)
      regex = %r{\[url(=(.*?))?:#{id}\](.*?)\[/url:#{id}\]}m
      return text unless text =~ regex
      urls = text.scan(regex)

      urls.each do |u|
        if u[0].nil?
          url = u[2]
          url_unescaped = url.gsub('&#58;', ':').gsub('&#46;', '.')
          text.gsub!("[url:#{id}]#{url}[/url:#{id}]",
                     "\s[#{url_unescaped}](#{url_unescaped})\s")
        else
          url = u[1]
          url_unescaped = url.gsub('&#58;', ':').gsub('&#46;', '.')
          url_text = u[2]
          text.gsub!("[url=#{url}:#{id}]" \
                     "#{url_text}[/url:#{id}]",
                     "\s[#{url_text}](#{url_unescaped})\s")
        end
      end
      text
    end

    def parse1(text, id)
      regex = %r{\[url\](.*?)\[/url\]}m
      return text unless text =~ regex
      urls = text.scan(regex)
      urls.each do |u|
        text.gsub!("[url]#{u[0]}[/url]", "[#{u[0]}](#{u[0]})")
      end
      text
    end
  end
end
