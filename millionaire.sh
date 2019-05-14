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

# Kiểm tra input
if [ -f cauhoi.txt ]; then
	:
else
	echo "Thiếu file câu hỏi cauhoi.txt"
	exit 1
fi

soCau=`cat cauhoi.txt | wc -l | awk '{print $1}'`
cauhoiFormat=`cat cauhoi.txt | sed -n '/^..*|[1-4]|..*|..*|..*|..*$/p' | wc -l | awk '{print $1}'`
if [ $soCau -ne $cauhoiFormat ]; then
	echo "File cauhoi.txt sai cấu trúc"
	echo "Cấu trúc đúng: Câu hỏi | STT câu đúng (1,2,3,4) | Câu A | Câu B | Câu C | Câu D "
	echo "VD: Hệ điều hành phổ biến nhất?|2|MacOS|Windows|Ubuntu|CentOS"
	exit 2
fi

if [ -f .progress.txt ]; then
	echo "Tồn tại file .progress.txt trong cùng thư mục. Vui lòng xóa file hoặc di chuyển millionaire.sh và cauhoi.txt đến thư mục khác"
	exit 3
fi

# Khởi động trò chơi
clear
echo "Chào mừng đến với chương trình Đi tìm triệu phú!"
echo "Được viết bởi: Lưu Minh Hoàng, Ninh Ngọc Hiếu, Đàm Thế Hào"

echo "Số câu: "$soCau
echo "+++++"
echo "Nhấn phím bất kỳ để bắt đầu..."
read

daTraLoi=0

# Tạo file tiến trình
rm .progress.txt &> /dev/null
for ((i=0; i<$soCau; i++)); do
	echo "0|0" >> .progress.txt
done

# TrangThai: 0: Chưa chọn; 1: Đã bỏ qua; 2: Đã chọn
# ChonDung: 0: Sai; 1: Đúng
trogiup1=0
trogiup2=0

while [ $daTraLoi -ne $soCau ]; do
	clear
	#cat .progress.txt
	#echo "da tra loi: $daTraLoi"
	# Đọc dữ liệu tiến trình của người chơi hiện tại
	#trangThai=()
	#chonDung=()
	#while read line; do
		#trangThai+=(`echo $line | cut -d'|' -f1`)
		#chonDung+=(`echo $line | cut -d'|' -f2`)
	#done < .progress.txt
	#rm .progress.txt &> /dev/null
	
	# Lấy câu hỏi chưa chọn
	current=$(( ($RANDOM%$soCau) +1))
	current_trangThai=`cat .progress.txt | head -$current | tail -1 | cut -d'|' -f1`
	until [ $current_trangThai -eq 0 ] || `[ $daTraLoi -eq $(($soCau-1)) ] && [ $current_trangThai -eq 1 ]`; do
		current=$(( ($RANDOM%$soCau) +1))
		current_trangThai=`cat .progress.txt | head -$current | tail -1 | cut -d'|' -f1`
	done
	#echo "Câu hiện tại: "$current

	# Xuất câu hỏi từ cauhoi.txt
	cauhoi=`cat cauhoi.txt | head -$(($current)) | tail -1 | cut -d'|' -f1`
	echo "Câu hỏi: $cauhoi"

	# Hiển thị câu trả lời
	cauArr=()
	cauArr[1]="A: `cat cauhoi.txt | head -$(($current)) | tail -1 | cut -d'|' -f3` "
	cauArr[2]="B: `cat cauhoi.txt | head -$(($current)) | tail -1 | cut -d'|' -f4` "
	cauArr[3]="C: `cat cauhoi.txt | head -$(($current)) | tail -1 | cut -d'|' -f5` "
	cauArr[4]="D: `cat cauhoi.txt | head -$(($current)) | tail -1 | cut -d'|' -f6` "
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
	cauDung=`cat cauhoi.txt | head -$(($current)) | tail -1 | cut -d'|' -f2`
	while [ $chonCau -eq 0 ]; do
		read -p "Vui lòng nhập: " getInput
		case $getInput in
			1)
				cau5050
				;;
			2)
				if [ $trogiup2 -eq 0 ]; then
					#trangThai[$current]=1
					sed -i '' $current's/.|/1|/' .progress.txt
					echo "Tiến hành đổi câu hỏi"
					#cat .progress.txt
					trogiup2=1
					break
				else
					echo "Đã hết quyền trở giúp Đổi câu hỏi"
				fi
				;;
			[Aa])
				echo "Chọn câu A"
				chonCau=1
				daTraLoi=$(($daTraLoi+1))
				#trangThai[$current]=2
				sed -i '' $current's/.|/2|/' .progress.txt
				;;
			[Bb])
				echo "Chọn câu B"
				chonCau=2
				daTraLoi=$(($daTraLoi+1))
				#trangThai[$current]=2
				sed -i '' $current's/.|/2|/' .progress.txt
				;;
			[Cc])
				echo "Chọn câu C"
				chonCau=3
				daTraLoi=$(($daTraLoi+1))
				#trangThai[$current]=2
				sed -i '' $current's/.|/2|/' .progress.txt
				;;
			[Dd])
				echo "Chọn câu D"
				chonCau=4
				daTraLoi=$(($daTraLoi+1))
				#trangThai[$current]=2
				sed -i '' $current's/.|/2|/' .progress.txt
				;;
			*)
				echo "Lỗi"
				;;
		esac
	done

	# Đúng hay sai
	if [ $chonCau -ne 0 ]; then
		if [ $chonCau -eq $cauDung ]; then
			echo "Đúng! +100 điểm!"
			#chonDung[$current]=1
			sed -i '' $current's/|./|1/' .progress.txt
			
		else
			echo "Sai..."
			echo "Câu trả lời đúng là: ${cauArr[$(($cauDung))]}"
			#chonDung[$current]=0
			sed -i '' $current's/|./|0/' .progress.txt
			#Ket thuc
			daTraLoi=$soCau
		fi
	fi
	
	# Lưu tiến trình: Câu hỏi đã chọn
	#for ((i=0; i<$soCau; i++)); do
		#echo ${trangThai[$i]}"|"${chonDung[$i]} >> .progress.txt 
	#done
	
	# Nhấn để tiếp tục
	echo "--- Nhấn phím bất kỳ để tiếp tục... ---"
	read
done

# Tính điểm
diem=0
while read line; do
	diem=$(($diem + `echo $line | cut -d'|' -f2` ))
done < .progress.txt
diem=$(($diem*100))
echo "---"
echo "Điểm: $diem"
rm .progress.txt &> /dev/null
