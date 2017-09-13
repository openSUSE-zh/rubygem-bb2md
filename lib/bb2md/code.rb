module BB2MD
  class Code
    attr_reader :text
    def initialize(text)
      @text = parse(text)
    end

    private

    def parse(text)
      blocks = text.scan(%r{\[code:(.*?)\](.*?)\[/code:.*?\]}m)
      text = parse_long_block(text, blocks)
      text = parse_short_block(text, blocks)
      text
    end

    def parse_long_block(text, blocks)
      b = blocks.select { |i| i[1].strip.index("\n") }
      return text if b.empty?

      strs = b.map do |c|
        arr = c[1].split("\n").map! { |i| i.gsub(/^/, "\s\s\s\s") }
        [c[0], arr.join("\n")]
      end

      b.each { |c| text.gsub!(c[1], '') }

      text = BB2MD::Style.parse(text)

      strs.each do |s|
        text.gsub!("[code:#{s[0]}][/code:#{s[0]}]", "\n#{s[1]}\n")
      end

      text
    end

    def parse_short_block(text, blocks)
      b = blocks.reject { |i| i[1].strip.index("\n") }
      return text if b.empty?
      b.each do |c|
        text.gsub!("[code:#{c[0]}]#{c[1]}[/code:#{c[0]}]",
                   "\n\s\s\s\s#{c[1]}\n")
      end
      text = BB2MD::Style.parse(text)
    end
  end
end
