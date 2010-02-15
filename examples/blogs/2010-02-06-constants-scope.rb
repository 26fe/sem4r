class A
  C = "c"
end

puts RUBY_VERSION
A.new.instance_eval do
  puts C
end
