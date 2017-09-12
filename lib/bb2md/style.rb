module BB2MD
  class Style
    class << self
      def method_missing(style, symbol, text, replaced)
        super unless [:bold, :italic, :underline, :strike, :color, :size].include?(style)
        regex = /\[#{symbol}.*?:(.*?)\](.*?)\[\/#{symbol}:.*?\]/m
        return unless text =~ regex
        vars = text.scan(regex)
        vars.each do |v|
          text.gsub!(/\[#{symbol}.*?:#{v[0]}\]#{Regexp.escape(v[1])}\[\/#{symbol}:#{v[0]}\]/, replaced + v[1] + replaced)
        end
        text
      end

      def respond_to_missing?(style)
        [:bold, :italic, :underline, :strike, :color, :size].include?(style) || super
      end
    end
  end
end
