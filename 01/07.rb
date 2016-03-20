=begin
07. テンプレートによる文生成
引数x, y, zを受け取り「x時のyはz」という文字列を返す関数を実装せよ．さらに，x=12, y="気温", z=22.4として，実行結果を確認せよ．
=end

def text_generate(x, y, z)
  str = x.to_s + '時の' + y.to_s + 'は' + z.to_s
  return str
end

x = 12
y = '気温'
z = 22.4

puts text_generate(x, y, z)
