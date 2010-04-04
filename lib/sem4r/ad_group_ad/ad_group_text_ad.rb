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

module Sem4r
  class AdGroupTextAd < AdGroupAd

    g_accessor :headline
    g_accessor :description1
    g_accessor :description2

    def initialize(ad_group, &block)
      self.type = TextAd
      super
    end

    def to_s
      "#{@id} textad #{@textad[:url]}"
    end

    def xml(t)
      t.adGroupId   ad_group.id
      t.ad("xsi:type" => "TextAd") do |ad|
        ad.url              url
        ad.displayUrl       display_url
        ad.headline         headline
        ad.description1     description1
        ad.description2     description2
      end
      t.status status
    end

    def to_xml(tag)
      builder = Builder::XmlMarkup.new
      builder.tag!(tag, "xsi:type" => "AdGroupAd") do |t|
        xml(t)
        #        t.adGroupId   ad_group.id
        #        t.ad("xsi:type" => "TextAd") do |ad|
        #          ad.url              url
        #          ad.displayUrl       display_url
        #          ad.headline         headline
        #          ad.description1     description1
        #          ad.description2     description2
        #        end
        #        t.status status
      end
    end

    def self.from_element(ad_group, el)
      new(ad_group) do
        @id         = el.elements["id"].text.strip.to_i
        # type          el.elements["Ad.Type"].text
        url           el.elements["url"].text.strip
        display_url   el.elements["displayUrl"].text.strip
        headline      el.elements["headline"].text.strip
        description1  el.elements["description1"].text.strip
        description2  el.elements["description2"].text.strip
      end
    end

    def self.create(ad_group, &block)
      new(ad_group, &block).save
    end

    def save
      soap_message = service.ad_group_ad.create(credentials, to_xml("operand"))
      add_counters( soap_message.counters )
      rval = REXML::XPath.first( soap_message.response, "//mutateResponse/rval")
      id = REXML::XPath.match( rval, "value/ad/id" ).first
      @id = id.text.strip.to_i
      self
    end

  end
end
