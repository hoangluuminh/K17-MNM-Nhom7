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
	echo "Câu hỏi: $cauhoi"

	# Hiển thị câu trả lời
	cauA=`cat cauhoi.txt | head -$current | tail -1 | cut -d'|' -f3`
	cauB=`cat cauhoi.txt | head -$current | tail -1 | cut -d'|' -f4`
	cauC=`cat cauhoi.txt | head -$current | tail -1 | cut -d'|' -f5`
	cauD=`cat cauhoi.txt | head -$current | tail -1 | cut -d'|' -f6`
	echo "A: $cauA"
	echo "B: $cauB"
	echo "C: $cauC"
	echo "D: $cauD"

	# Nhận input từ người chơi
	echo "Tùy chọn: "
	echo "   1: 50/50"
	echo "   2: Đổi câu hỏi"
	echo "---"
	read -p "Vui lòng nhập: " getInput

	# Xử lý input
	case $getInput in
		"1")
			trangThai[$current]=1
			echo "Tiến hành chọn 50/50"
			;;
	esac
	
	# Lưu tiến trình: Câu hỏi đã chọn
	trangThai[$current]=2
	for ((i=1; i<=$soCau; i++)); do
		echo ${trangThai[$i]}"|"${chonDung[$i]} >> progress.txt 
	done
	
	read
done

