module BB2MD
  # Parse the lists
  class List
    attr_reader :text
    def initialize(text, id)
      @text = recursive_parse(text, id)
    end

    private

    def recursive_parse(text, id)
      regex = %r{\[list(.*?):#{id}\](.*?)\[/list:(o|u):#{id}\]}m
      regex_item = %r{\[\*:#{id}\](.*?)\[/\*:m:#{id}\]}m
      lists = text.scan(regex)
      return text if lists.empty?
      lists.each do |i|
        if i[1] =~ /\[list(.*?):#{id}\](.*)$/m
          index = Regexp.last_match[1]
          str = Regexp.last_match[2]
          text = parse(index, str, i[2], regex_item, text, id)
        else
          text = parse(i[0], i[1], i[2], regex_item, text, id)
        end
      end

      # second round
      new_lists = text.scan(regex)
      return text if new_lists.empty?
      new_lists.each do |j|
        text = parse(j[0], j[1], j[2], regex_item, text, id)
      end

      text
    end

    def parse(index, str, type, regex, text, id)
      new_text = ''
      vars = str.scan(regex)
      return text if vars.empty?
      if type == 'u'
        # unordered
        vars.each do |item|
          new_text << "* #{item[0]}\n"
        end
      else
        # ordered
        j = 1
        vars.each do |item|
          new_text << "#{j}. #{item[0]}\n"
          j += 1
        end
      end
      text.sub!("[list#{index}:#{id}]#{str}[/list:#{type}:#{id}]",
                new_text)
    end
  end
end
