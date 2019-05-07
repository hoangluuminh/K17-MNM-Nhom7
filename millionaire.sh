#!/bin/bash
clear
echo "Chào mừng đến với chương trình Đi tìm triệu phú!"

soCau=0
while read line; do
	soCau=$(($soCau+1))
done < cauhoi.txt
echo "Số câu: "$soCau

continue=1
while [ $continue -eq 1 ]; do
	current=$(( ($RANDOM%$soCau) +1))
	echo "Câu hiện tại: "$current
	# Xuất câu hỏi từ cauhoi.txt
	cauhoi=`cat cauhoi.txt | head -$current | tail -1`
	#
	# Lưu tiến trình: Câu hỏi đã chọn

	echo $cauhoi
	read
done
