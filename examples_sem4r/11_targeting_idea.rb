# -*- coding: utf-8 -*-
# -------------------------------------------------------------------------
# Copyright (c) 2009-2010 Sem4r sem4ruby@gmail.com
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# -------------------------------------------------------------------------

require File.expand_path( File.join( File.dirname(__FILE__), "example_helper") )

run_example(__FILE__) do |adwords|
  account = adwords.account

  ideas = account.targeting_idea  do
    idea_type    "KEYWORD"
    request_type "IDEAS"

    requested_attributes %w{KEYWORD IDEA_TYPE KEYWORD_CATEGORY NGRAM_GROUP}

    excluded_keyword_search_parameter do
      text       'media player'
      match_type 'EXACT'
    end

    keyword_match_type_search_parameter do
      match_type 'BROAD'
      match_type 'EXACT'
    end

    related_to_keyword_search_parameter do
      text       'dvd player'
      match_type 'EXACT'
    end

    country_target_search_parameter do
      country_code 'US'
      # country_code 'UK'
      # country_code 'IT'
    end

  end

  ideas.each{ |idea| puts idea }

end
