# -------------------------------------------------------------------
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
# -------------------------------------------------------------------

module Sem4r
  class CriterionKeyword < Criterion

    enum :KeywordMatches,    [:EXACT, :BROAD, :PHRASE]

    g_accessor :text
    g_accessor :match

    def initialize(ad_group, text = nil, match = "BROAD", &block)
      super( ad_group )
      self.type = Keyword
      self.text = text   unless text.nil?     # TODO: text == nil raise error
      self.match = match unless match.nil?
      if block_given?
        @inside_initialize = true
        block.arity < 1 ? instance_eval(&block) : block.call(self)
      end
      @inside_initialize = false
    end

    def inside_initialize?
      @inside_initialize
    end

    def self.create(ad_group, &block)
      new(ad_group, &block).save
    end

    def self.from_element( ad_group, el )
      new(ad_group) do@id      = el.xpath("id").text.strip.to_i
        text       el.xpath("text").text.strip
        match      el.xpath("matchType").text.strip
      end
    end

    def to_s
      "#{saved? ? id : 'unsaved' } #{type} #{text} #{match}"
    end

    def xml(t)
      t.criterion("xsi:type" => "#{type}") { |t| 
        t.text        text
        t.matchType   match
      }
    end

    def to_xml(tag)
      builder = Builder::XmlMarkup.new
      builder.tag!(tag, "xsi:type" => "#{type}") do |t|
        t.text        text
        t.matchType   match
      end
    end

  end
end
