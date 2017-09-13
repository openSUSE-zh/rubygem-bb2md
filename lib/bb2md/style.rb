module BB2MD
  class Style
    class << self
      def method_missing(style, symbol, text, replaced)
        super unless %i[bold italic underline strike color size].include?(style)
        regex = %r{\[#{symbol}.*?:(.*?)\](.*?)\[/#{symbol}:.*?\]}m
        vars = text.scan(regex)
        return text if vars.empty?
        vars.each do |v|
          r = %r{\[#{symbol}.*?:#{v[0]}\]#{Regexp.escape(v[1])}\[/#{symbol}:#{v[0]}\]}
          text.gsub!(r, replaced + v[1] + replaced)
        end
        text
      end

      def respond_to_missing?(style)
        %i[bold italic underline strike color size].include?(style) || super
      end
    end

    SYMBOLS = [[:bold, 'b', '**'],
               [:italic, 'i', '*'],
               [:underline, 'u', '__'],
               [:strike, 's', '~~'],
               [:color, 'color', ''],
               [:size, 'size', '']].freeze

    def self.parse(text)
      SYMBOLS.each do |arr|
        text = self.send(arr[0], arr[1], text, arr[2])
      end
      text
    end
  end
end
