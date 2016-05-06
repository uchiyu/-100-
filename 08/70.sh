# 70. データの入手・整形
# 文に関する極性分析の正解データを用い，以下の要領で正解データ（sentiment.txt）を作成せよ．
# 
# rt-polarity.posの各行の先頭に"+1 "という文字列を追加する（極性ラベル"+1"とスペースに続けて肯定的な文の内容が続く）
# rt-polarity.negの各行の先頭に"-1 "という文字列を追加する（極性ラベル"-1"とスペースに続けて否定的な文の内容が続く）
# 上述1と2の内容を結合（concatenate）し，行をランダムに並び替える
# sentiment.txtを作成したら，正例（肯定的な文）の数と負例（否定的な文）の数を確認せよ．

# 教師データの生成
tar zxvf ./rt-polaritydata.tar.gz
sed "s/^/+1 /g" ./rt-polaritydata/rt-polarity.pos > tmp.txt
sed "s/^/-1 /g" ./rt-polaritydata/rt-polarity.neg >> tmp.txt
rm -f ./rt-polaritydata.README.1.0.txt
rm -rf ./rt-polaritydata

shuf tmp.txt > sentiment.txt
rm -f ./tmp.txt

# ネガポジデータの件数のカウント
echo "pos count is `grep "^+1 " sentiment.txt | wc -l`"
echo "neg count is `grep "^-1 " sentiment.txt | wc -l`"
