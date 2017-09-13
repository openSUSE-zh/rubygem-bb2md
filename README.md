bb2md

------

[![Code Climate](https://codeclimate.com/github/openSUSE-zh/rubygem-bb2md/badges/gpa.svg)](https://codeclimate.com/github/openSUSE-zh/rubygem-bb2md)

Convert bbcodes in a phpbb3 post to markdown.

Currently it covers:

* bold, italic, underline, strikethrough
* font size & color
* img
* url & postlink
* quote

Simple usage:

    bin/bb2md "phpbb3 post" "bbcode_uid"

Advanced usage:

    require 'bb2md'
    BB2MD::Parser.new("post", "bbcode_uid").parse

bbcode_uid can be found from phpbb_posts table with phpmyadmin.


