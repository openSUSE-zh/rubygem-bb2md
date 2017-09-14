module BB2MD
  # Parse the URLs
  class URL
    attr_reader :text
    def initialize(text, id)
      @text = parse(text, id)
      @text = parse_plain_url(@text, id)
      @text = parse_postlink(@text, id)
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

    def parse_plain_url(text, id)
      regex = %r{\[url\](.*?)\[/url\]}m
      urls = text.scan(regex)
      return text if urls.empty?
      urls.each do |u|
        text.gsub!("[url]#{u[0]}[/url]", "[#{u[0]}](#{u[0]})")
      end
      text
    end

    def parse_postlink(text, id)
      regex = %r{<\!-- [a-z] --><a class="postlink" href="(.*?)">.*?</a><\!-- [a-z] -->}m
      urls = text.scan(regex)
      return text if urls.empty?
      urls.each do |u|
        if u[0] =~ /\.(png|jpg|jpeg|gif)$/
          replaced = "![](#{u[0]})"
        else
          replaced = "[#{u[0]}](#{u[0]})"
        end

        text.sub!(%r{<\!-- [a-z] --><a class="postlink" href="#{Regexp.escape(u[0])}">.*?</a><\!-- [a-z] -->},
                  replaced)
      end
      text
    end
  end
end
