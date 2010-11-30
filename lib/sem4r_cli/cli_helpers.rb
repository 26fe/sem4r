# -*- coding: utf-8 -*-
module Sem4r
  # From http://gist.github.com/72234
  #
  # mysql-style output for an array of ActiveRecord objects
  #
  # Usage:
  #   report(records)  # displays report with all fields
  #   report(records, :field1, :field2, ...) # displays report with given fields
  #
  # Example:
  # >> report(records, :id, :amount, :created_at)
  # +------+-----------+--------------------------------+
  # | id   | amount    | created_at                     |
  # +------+-----------+--------------------------------+
  # | 8301 | $12.40    | Sat Feb 28 09:20:47 -0800 2009 |
  # | 6060 | $39.62    | Sun Feb 15 14:45:38 -0800 2009 |
  # | 6061 | $167.52   | Sun Feb 15 14:45:38 -0800 2009 |
  # | 6067 | $12.00    | Sun Feb 15 14:45:40 -0800 2009 |
  # | 6059 | $1,000.00 | Sun Feb 15 14:45:38 -0800 2009 |
  # +------+-----------+--------------------------------+
  # 5 rows in set
  #
  def self.report(items, *fields) #:nodoc: all
    # find max length for each field; start with the field names themselves
    max_len = Hash[*fields.map {|f| [f, f.to_s.length]}.flatten]

    items.each do |item|
      fields.each do |field|
        len = item.send(field).to_s.length
        max_len[field] = len if len > max_len[field]
      end
    end

    border = '+-' + fields.map {|f| '-' * max_len[f] }.join('-+-') + '-+'
    title_row = '| ' + fields.map {|f| sprintf("%-#{max_len[f]}s", f.to_s) }.join(' | ') + ' |'

    puts border
    puts title_row
    puts border

    items.each do |item|
      row = '| ' + fields.map {|f| sprintf("%-#{max_len[f]}s", item.send(f)) }.join(' | ') + ' |'
      puts row
    end

    puts border
    puts "#{items.length} rows in set\n"
  end
end

if __FILE__ == $0
  require 'ostruct'
  o = OpenStruct.new
  o.a = 1
  o.b = 2
  Sem4r::report( [o], :a, :b )
end
