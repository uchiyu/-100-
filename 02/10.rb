=begin
10. 行数のカウント
行数をカウントせよ．確認にはwcコマンドを用いよ．
=end

p File.read('hightemp.txt').count("\n")
p %x( wc -l 'hightemp.txt' )
