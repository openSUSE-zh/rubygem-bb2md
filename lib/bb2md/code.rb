#require 'latincjk'
#require 'suse_typo'

module BB2MD
  class Code
    attr_reader :text
    def initialize(text, id)
      @text = parse(text, id)
    end

    private

    def parse(text, id)
      blocks = text.scan(%r{\[code:#{id}\](.*?)\[/code:#{id}\]}m)
      return parse_no_code(text, id) if blocks.empty?
      blocks.map! {|i| i[0] }

      text = parse_long_block(text, id, blocks)
      text = parse_short_block(text, id, blocks)
      text
    end

    def parse_long_block(text, id, blocks)
      b = blocks.select { |i| i.strip.index("\n") }

      return parse_no_code(text, id) if b.empty?

      strs = b.map do |c|
        arr = c.split("\n").map! { |i| i.gsub(/^/, "\t") }
        arr.join("\n")
      end

      b.each_with_index { |c,i| text.gsub!(c, i.to_s) }

      text = parse_no_code(text, id)

      strs.each_with_index do |s,i|
	      text.gsub!("[code:#{id}]#{i.to_s}[/code:#{id}]", "\n#{escape_backslash(s)}\n")
      end

      text
    end

    def parse_short_block(text, id, blocks)
      b = blocks.reject { |i| i.strip.index("\n") }
      return parse_no_code(text, id) if b.empty?
      b.each do |c|
        text.gsub!("[code:#{id}]#{c}[/code:#{id}]",
                   "\n\t#{escape_backslash(c)}\n")
      end
      text = parse_no_code(text, id)
    end

    def escape_backslash(text)
      # escape backslash in case of "\1" or "\&" left
      text.gsub(/\\(.*?)/) { "&#92;" + Regexp.last_match(1) }
    end

    def parse_no_code(text, id)
      t = BB2MD::Style.parse(text, id)
#      t = LatinCJK::Parser.new(t).text
#      t = SUSETypo::Parser.new(t).text
    end
  end
end
