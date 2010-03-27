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
  class Service

    def initialize(connector)
      @connector = connector
    end

    ###########################################################################
    # services v13

    %w{ account report traffic_estimator }.each do |service|
      klass_name = service.split('_').map{|p| p.capitalize}.join('')
      str=<<-EOFR
        require 'sem4r/v13_#{service}/#{service}_service'
        def #{service}
          return @#{service}_service if @#{service}_service
          @#{service}_service = #{klass_name}Service.new(@connector)
        end
      EOFR
      eval str
    end

    ###########################################################################
    # services v2009

    %w{ ad_extension_override
        ad_group
        ad_group_ad
        ad_param
        ad_group_criterion
        campaign
        campaign_criterion 
        campaign_target
        geo_location
        info
        targeting_idea
        bulk_mutate_job }.each do |service|
      klass_name = service.split('_').map{|p| p.capitalize}.join('')
      str=<<-EOFR
        require 'sem4r/#{service}/#{service}_service'
        def #{service}
          return @#{service}_service if @#{service}_service
          @#{service}_service = #{klass_name}Service.new(@connector)
        end
      EOFR
      eval str
    end

  end
end
