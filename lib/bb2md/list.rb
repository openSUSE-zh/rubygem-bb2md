module BB2MD
  # Parse the lists
  class List
    attr_reader :text
    def initialize(text, id)
      @tagged, max = tag(text, id)
      @text = recursive_parse(@tagged, id, max)
    end

    private

    def tag(text, id)
      level = 0
      max = 0
      text.gsub!(%r{\[\/?list.*?:#{id}\]}) do |list|
        if list =~ /\[list/
          level += 1
          max = level if max < level
          level.to_s + '-' + list
        elsif list =~ %r{\[/list}
          level -= 1
          (level + 1).to_s + '-' + list
        end
      end
      [text, max]
    end

    def recursive_parse(text, id, round)
      return text if round.zero?
      regex = %r{#{round}-\[list(.*?):#{id}\](.*?)#{round}-\[/list:(o|u):#{id}\]}m
      regex_item = %r{\[\*:#{id}\](.*?)\[/\*:m:#{id}\]}m
      lists = text.scan(regex)
      return text if lists.empty?

      items = lambda do |i|
        vars = i[1].scan(regex_item)
        if vars.empty?
          parse_no_item(i, text, id, round)
        else
          parse(i, vars, text, id, round)
        end
      end

      lists.each { |i| text = items.call(i) }
      round -= 1
      recursive_parse(text, id, round)
    end

    def parse(i, vars, text, id, round)
      new_text = ''
      indent = "\t" * round
      if i[2] == 'u'
        j = '*'
      else
        j = 1
      end

      vars.each do |item|
        new_text << "#{indent}#{j}"
        new_text << "." if i[2] == 'o'
        new_text << "\s#{item[0]}\n"
        j += 1 if i[2] == 'o'
      end

      text.sub("#{round}-[list#{i[0]}:#{id}]#{i[1]}#{round}-[/list:#{i[2]}:#{id}]",
               new_text)
    end

    def parse_no_item(i, text, id, round)
      newstr = ''
      indent = "\t" * round

      parse = lambda do |str, num|
        if str[0] =~ /[0-9]/
          str.sub(str[0], indent + num + ".\s")
        elsif str[0] == '*'
          indent + str
        else
          indent + "*\s" + str
        end
      end

      if i[1].strip.index("\n")
        arr = i[1].strip.split("\n").map!(&:strip)
        if arr[0][0] =~ /[0-9]/
          j = 1
          arr.each { |a| newstr << parse.call(a, j.to_s) + "\n"; j += 1 }
        else
          arr.each { |a| newstr << parse.call(a, '') + "\n" }
        end
      else
        newstr = parse.call(i[1], '1')
      end

      text.sub("#{round}-[list#{i[0]}:#{id}]#{i[1]}#{round}-[/list:#{i[2]}:#{id}]",
               newstr)
    end
  end
end
