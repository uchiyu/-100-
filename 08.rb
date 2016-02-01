def cipher(text)
  str = ''
  text.each_char do |ch|
    str += ch =~ /[a-z]/ ? (219 - ch.to_s.ord).to_s.chr : ch
  end
  return str
end

text = 'Hello, うっちー'
puts cipher(text)

