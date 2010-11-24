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
  class CriterionPlacement < Criterion

    g_accessor :url

    def initialize(ad_group, url = nil, &block)
      super( ad_group )
      self.type = Placement
      self.url = url unless url.nil?
      if block_given?
        block.arity < 1 ? instance_eval(&block) : block.call(self)
      end
    end

    def self.create(ad_group, &block)
      new(ad_group, &block).save
    end

    def self.from_element( ad_group, el )
      new(ad_group) do
        @id      = el.elements["id"].text.strip.to_i
        url        el.elements["url"].text.strip
        #=======
        #        @id      = el.at_xpath("id").text.strip.to_i
        #        url        el.at_xpath("url").text.strip
        #>>>>>>> wordtracker/master
      end
    end

    def to_s
      "#{saved? ? id : 'unsaved'} #{type} #{url}"
    end

    def xml(t)
      t.criterion("xsi:type" => "#{type}") do |ad|
        ad.url  url
      end
    end

    def to_xml(tag)
      builder = Builder::XmlMarkup.new
      t = builder.tag!(tag, "xsi:type" => "CriterionKeyword")
      xml(t)
    end

  end
end
