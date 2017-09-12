module BB2MD
  # Parse the URLs
  class URL
    attr_reader :text
    def initialize(text)
      @text = parse(text) || text
      @text = parse1(@text) || @text
    end

    private

    def parse(text)
      regex = /\[url(=(.*?))?:(.*?)\](.*?)\[\/url:.*?\]/m
      return unless text =~ regex
      urls = text.scan(regex)
      urls.each do |u|
        if u[1].nil?
          url_id = u[2]
          url = u[3]
          url_unescaped = url.gsub("&#58;", ":").gsub("&#46;", ".")
          text.gsub!("[url:#{url_id}]#{url}[/url:#{url_id}]", "[#{url_unescaped}](#{url_unescaped})")
        else
          url = u[1]
          url_unescaped = url.gsub("&#58;", ":").gsub("&#46;", ".")
          url_id = u[2]
          url_text = u[3]
          text.gsub!("[url=#{url}:#{url_id}]#{url_text}[/url:#{url_id}]", "[#{url_text}](#{url_unescaped})")
        end
      end
      text
    end

    def parse1(text)
      regex = /\[url\](.*?)\[\/url\]/m
      return text unless text =~ regex
      urls = text.scan(regex)
      urls.each do |u|
        text.gsub!("[url]#{u[0]}[/url]", "[#{u[0]}](#{u[0]})")
      end
      text
    end
  end
end
