module BB2MD
  class Code
    attr_reader :text
    def initialize(text)
      @text = parse(text) || text
    end

    private

    def parse(text)
      blocks = text.scan(/\[code:(.*?)\](.*?)\[\/code:.*?\]/m)
      blocks.each do |code|
        if code[1].index("\n")
          arr = code[1].split("\n").map! {|i| i.gsub(/^/, "\s\s\s\s") }
          str = arr.join("\n")
          text.gsub!("#{code[1]}", "")
          text.gsub!("[code:#{code[0]}][/code:#{code[0]}]", "\n#{str}\n")
        else
          text.gsub!("[code:#{code[0]}]#{code[1]}[/code:#{code[0]}]", "\n\s\s\s\s#{code[1]}\n")
        end
      end
      text
    end
  end
end
