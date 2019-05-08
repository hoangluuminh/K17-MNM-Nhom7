#!/bin/bash
clear
echo "Chào mừng đến với chương trình Đi tìm triệu phú!"

soCau=`cat cauhoi.txt | wc -l | awk '{print $1}'`
echo "Số câu: "$soCau

# Tạo file tiến trình
rm progress.txt &> /dev/null
for ((i=1; i<=$soCau; i++)); do
	echo "0|0" >> progress.txt
done

# TrangThai: 0: Chưa chọn; 1: Đã bỏ qua; 2: Đã chọn
# ChonDung: 0: Sai; 1: Đúng
trangThai=()
chonDung=()

continue=1
while [ $continue -eq 1 ]; do
	# Lấy câu hỏi chưa chọn
	current=$(( ($RANDOM%$soCau) +1))
	while [ `cat progress.txt | head -$current | tail -1 | cut -d'|' -f1` -ne 0 ]; do
		current=$(( ($RANDOM%$soCau) +1))
	done
	
	# Đọc dữ liệu tiến trình của người chơi hiện tại
	while read line; do
		trangThai+=(`echo $line | cut -d'|' -f1`)
		chonDung+=(`echo $line | cut -d'|' -f2`)
	done < progress.txt
	rm progress.txt &> /dev/null
	echo "Câu hiện tại: "$current

	# Xuất câu hỏi từ cauhoi.txt
	cauhoi=`cat cauhoi.txt | head -$current | tail -1 | cut -d'|' -f1`
	echo $cauhoi

	# Hiển thị câu hỏi
	
	# Lưu tiến trình: Câu hỏi đã chọn
	trangThai[$current]=2
	for ((i=1; i<=$soCau; i++)); do
		echo ${trangThai[$i]}"|"${chonDung[$i]} >> progress.txt 
	done
	
	read
done

