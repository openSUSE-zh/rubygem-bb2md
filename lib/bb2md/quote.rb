module BB2MD
  # Parse the quoted text
  class Quote
    attr_reader :text
    def initialize(text)
      @text = parse(text) || text
    end

    private

    def parse(text)
      # discourse doesn't support nested quotes
      # and you can't insert next line in quote
      regex = /\[quote(=&quot;(.*?)&quot;)?:(.*?)\]/m
      return unless text =~ regex
      quotes = text.scan(regex).map { |i| i[1..-1] }

      first_quote_id = quotes[0][1]
      first_quoted_user = quotes[0][0] unless quotes[0][0].nil?

      first_start_quote = if first_quoted_user.nil?
                            "[quote:#{first_quote_id}]"
                          else
                            "[quote=&quot;#{first_quoted_user}&quot;:#{first_quote_id}]"
                          end
      first_end_quote = "[/quote:#{first_quote_id}]"

      quoted_text = text.match(/#{Regexp.escape(first_start_quote)}(.*?)#{Regexp.escape(first_end_quote)}/m)[1]

      escaped_quoted_text = escape(quoted_text)

      text.gsub(first_start_quote + quoted_text + first_end_quote,
                first_start_quote.sub(/:.*$/, ']') + escaped_quoted_text + '[/quote]')
    end

    def escape(text)
      # escape any nested quotes
      text = text.gsub(%r{\[quote.*\].*?\[/quote.*\]}, '')
      # escape any code blocks
      text = text.gsub(%r{\[code.*\].*?\[/code.*\]}, '')
      # escape 'sent from .* using *' generated by tapatalk
      text.gsub(/Sent\s+from.*?using\s+Tapatalk\s+2/, '')
    end
  end
end
