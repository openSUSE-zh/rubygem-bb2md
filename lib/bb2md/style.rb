module BB2MD
  class Style
    class << self
      def method_missing(style, symbol, replaced, text, id)
        super unless %i[bold italic underline strike color size].include?(style)
        regex = %r{\[#{symbol}.*?:#{id}\](.*?)\[/#{symbol}:#{id}\]}m
        vars = text.scan(regex)
        return text if vars.empty?
        vars.map! {|i| i[0] }
        vars.each do |v|
          r = %r{\[#{symbol}.*?:#{id}\]#{Regexp.escape(v)}\[/#{symbol}:#{id}\]}
          text.gsub!(r, "\s" + replaced + v + replaced + "\s")
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

    def self.parse(text, id)
      SYMBOLS.each do |arr|
        text = self.send(arr[0], arr[1], arr[2], text, id)
      end
      text
    end
  end
end
