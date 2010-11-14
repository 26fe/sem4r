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

require 'yaml'
require 'pathname'
require 'rubygems'
require 'builder'
require 'rexml/document'
require 'uri'
require 'pp'
require 'logger'
require 'fileutils'

module Sem4r #:nodoc:
  def self.version
    cwd = Pathname(__FILE__).dirname.expand_path.to_s
    yaml = YAML.load_file(cwd + '/../VERSION.yml')
    major = (yaml['major'] || yaml[:major]).to_i
    minor = (yaml['minor'] || yaml[:minor]).to_i
    patch = (yaml['patch'] || yaml[:patch]).to_i
    "#{major}.#{minor}.#{patch}"
  end
end

cwd = Pathname(__FILE__).dirname
$:.unshift(cwd.to_s) unless $:.include?(cwd.to_s) || $:.include?(cwd.expand_path.to_s)

require 'sem4r/extensions.rb'

require 'sem4r/adwords'
require 'sem4r/credentials'
require 'sem4r/sem4r_error'
require 'sem4r/soap_attributes'

require 'sem4r/base'
require 'sem4r/account'


#
# soap connection layer
#
require 'sem4r/services/soap_error'
require 'sem4r/services/soap_connector'
require 'sem4r/services/soap_message_v13'
require 'sem4r/services/soap_message_v2009'
require 'sem4r/services/soap_call'
require 'sem4r/services/service'

#
# common
#
require 'sem4r/common/operation'

#
# adgroup
#
require 'sem4r/ad_group/ad_group_bids'
require 'sem4r/ad_group/mobile_ad_image'
require 'sem4r/ad_group/ad_group'

#
# adgroup_ad
#
require 'sem4r/ad_group_ad/ad_group_ad_operations'
require 'sem4r/ad_group_ad/ad_group_ad'
require 'sem4r/ad_group_ad/ad_group_text_ad'
require 'sem4r/ad_group_ad/ad_group_mobile_ad'

#
# adgroup_criterion
#
require 'sem4r/ad_group_criterion/ad_group_criterion_bids'
require 'sem4r/ad_group_criterion/ad_group_criterion_operations'
require 'sem4r/ad_group_criterion/criterion'
require 'sem4r/ad_group_criterion/criterion_keyword'
require 'sem4r/ad_group_criterion/criterion_placement'
require 'sem4r/ad_group_criterion/ad_group_criterion'

#
# ad_param
#
require 'sem4r/ad_param/ad_param'
require 'sem4r/ad_param/ad_param_operation'

#
# bulk_mutate_job
#
require 'sem4r/bulk_mutate_job/job_operations'
require 'sem4r/bulk_mutate_job/bulk_mutate_job_selector'
require 'sem4r/bulk_mutate_job/bulk_mutate_job'

#
# campaign
#
require 'sem4r/campaign/campaign'


#
# targeting_idea
#
require 'sem4r/targeting_idea/targeting_idea'
require 'sem4r/targeting_idea/targeting_idea_selector'

#
# v13_account
#
require 'sem4r/v13_account/billing_address'

#
# v13_report
#
require 'sem4r/v13_report/report'
require 'sem4r/v13_report/report_job'


#
# report_definition
#
require 'sem4r/report_definition/report_definition'
require 'sem4r/report_definition/report_definition_selector'
require 'sem4r/report_definition/report_definition_operation'

