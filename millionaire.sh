#!/bin/bash

# functions
cau5050 () {
	if [ $trogiup1 -ne 0 ]; then
		echo "Đã hết quyền trở giúp 50/50"
		return
	fi
	echo "Tiến hành chọn 50/50"
	cau50=$(( ($RANDOM%4) +1))
	while [ $cau50 -eq $cauDung ]; do
		cau50=$(( ($RANDOM%4) +1))
	done
	for ((i=1; i<=4; i++)); do
		if [ $i -eq $cau50 ] || [ $i -eq $cauDung ]; then
			echo ${cauArr[$i]}
		fi
	done
	trogiup1=1
}
# END functions
clear
echo "Chào mừng đến với chương trình Đi tìm triệu phú!"

soCau=`cat cauhoi.txt | wc -l | awk '{print $1}'`
echo "Số câu: "$soCau
daTraLoi=0

# Tạo file tiến trình
rm progress.txt &> /dev/null
for ((i=0; i<$soCau; i++)); do
	echo "0|0" >> progress.txt
done

# TrangThai: 0: Chưa chọn; 1: Đã bỏ qua; 2: Đã chọn
# ChonDung: 0: Sai; 1: Đúng
trogiup1=0
trogiup2=0

continue=1
while [ $continue -eq 1 ]; do
	# Đọc dữ liệu tiến trình của người chơi hiện tại
	trangThai=()
	chonDung=()
	cat progress.txt
	while read line; do
		trangThai+=(`echo $line | cut -d'|' -f1`)
		chonDung+=(`echo $line | cut -d'|' -f2`)
	done < progress.txt
	rm progress.txt &> /dev/null
	
	# Lấy câu hỏi chưa chọn
	current=$(( ($RANDOM%$soCau) ))
	while [ ${trangThai[$current]} -ne 0 ]; do
		current=$(( ($RANDOM%$soCau) ))
	done
	echo "Câu hiện tại: "$current

	# Xuất câu hỏi từ cauhoi.txt
	cauhoi=`cat cauhoi.txt | head -$(($current+1)) | tail -1 | cut -d'|' -f1`
	echo "Câu hỏi: $cauhoi"

	# Hiển thị câu trả lời
	cauArr=()
	cauArr[1]="A: `cat cauhoi.txt | head -$(($current+1)) | tail -1 | cut -d'|' -f3` "
	cauArr[2]="B: `cat cauhoi.txt | head -$(($current+1)) | tail -1 | cut -d'|' -f4` "
	cauArr[3]="C: `cat cauhoi.txt | head -$(($current+1)) | tail -1 | cut -d'|' -f5` "
	cauArr[4]="D: `cat cauhoi.txt | head -$(($current+1)) | tail -1 | cut -d'|' -f6` "
	for ((i=1; i<=4; i++)); do
		echo ${cauArr[$i]}
	done

	# Xuất thông báo Nhận input từ người chơi
	getInput=""
	echo "Tùy chọn: "
	echo "   1: 50/50"
	echo "   2: Đổi câu hỏi"
	echo "---"

	# Xử lý input
	chonCau=0
	cauDung=`cat cauhoi.txt | head -$(($current+1)) | tail -1 | cut -d'|' -f2`
	while [ $chonCau -eq 0 ]; do
		read -p "Vui lòng nhập: " getInput
		case $getInput in
			1)
				cau5050
				;;
			2)
				trangThai[$current]=1
				echo "Tiến hành đổi câu hỏi"
				;;
			[Aa])
				echo "Chọn câu A"
				chonCau=1
				daTraLoi=$(($daTraLoi+1))
				trangThai[$current]=2
				;;
			[Bb])
				echo "Chọn câu B"
				chonCau=2
				daTraLoi=$(($daTraLoi+1))
				trangThai[$current]=2
				;;
			[Cc])
				echo "Chọn câu C"
				chonCau=3
				daTraLoi=$(($daTraLoi+1))
				trangThai[$current]=2
				;;
			[Dd])
				echo "Chọn câu D"
				chonCau=4
				daTraLoi=$(($daTraLoi+1))
				trangThai[$current]=2
				;;
			*)
				echo "Lỗi"
				read
				;;
		esac
	done

	# Đúng hay sai
	if [ $chonCau -eq $cauDung ]; then
		echo "Đúng! +1 điểm!"
		chonDung[$current]=1
		
	else
		echo "Sai..."
		echo "Câu trả lời đúng là: ${cauArr[$(($cauDung))]}"
		chonDung[$current]=0
	fi
	
	# Lưu tiến trình: Câu hỏi đã chọn
	
	for ((i=0; i<$soCau; i++)); do
		echo ${trangThai[$i]}"|"${chonDung[$i]} >> progress.txt 
	done
	
	read
done

			
