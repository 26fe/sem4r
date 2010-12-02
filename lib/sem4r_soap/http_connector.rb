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

module Sem4r
  module Soap

    class HttpConnector
      require 'net/https'
      require 'uri'
      # $stderr.puts "Using standard net/https"

      def get_sess_for_host(uri)
        @sessions ||= {}

        url = uri.scheme + "://" + uri.host
        sess = @sessions[url]
        unless sess
          sess = Net::HTTP.new(uri.host, uri.port)
          sess.use_ssl = (uri.scheme == "https")
          @sessions[url] = sess
        end
        sess
      end

      def invalidate_sess(uri)
        sess = @sessions[uri.host]
        if sess
          # sess.close
          @sessions[uri.host] = nil
        end
      end

      def download(url, path_name)
        require 'open-uri'
        data = open(url){ |f| f.read }
        File.open(path_name, "w") { |f| f.write(data) }
      end
    end

  end # module Soap
end # module Sem4r
