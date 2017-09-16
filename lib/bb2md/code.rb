module BB2MD
  class Code
    attr_reader :text
    def initialize(text, id)
      @text = parse(text, id)
    end

    private

    def parse(text, id)
      blocks = text.scan(%r{\[code:#{id}\](.*?)\[/code:#{id}\]}m)
      return BB2MD::Style.parse(text, id) if blocks.empty?
      blocks.map! {|i| i[0] }

      text = parse_long_block(text, id, blocks)
      text = parse_short_block(text, id, blocks)
      text
    end

    def parse_long_block(text, id, blocks)
      b = blocks.select { |i| i.strip.index("\n") }

      return BB2MD::Style.parse(text, id) if b.empty?

      strs = b.map do |c|
        arr = c.split("\n").map! { |i| i.gsub(/^/, "\t") }
        arr.join("\n")
      end

      b.each { |c| text.gsub!(c, '') }

      text = BB2MD::Style.parse(text, id)

      strs.each do |s|
        text.gsub!("[code:#{id}][/code:#{id}]", "\n#{s}\n")
      end

      text
    end

    def parse_short_block(text, id, blocks)
      b = blocks.reject { |i| i.strip.index("\n") }
      return BB2MD::Style.parse(text, id) if b.empty?
      b.each do |c|
        text.gsub!("[code:#{id}]#{c}[/code:#{id}]",
                   "\n\t#{c}\n")
      end
      text = BB2MD::Style.parse(text, id)
    end
  end
end
