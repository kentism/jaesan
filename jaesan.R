#패키지 호출, 작업환경 정리
library(dplyr)
rm(list = ls())

#작업환경 조성, 데이터 불러들이기
setwd("C:/Users/YTN/Desktop/jaesan")
gg <- read.csv("2017_gyeonggi.csv")

#필요한 Class 변환
gg$법정동명 <- as.character(gg$법정동명)
gg$지번 <- as.character(gg$지번)
gg$소유구분 <- as.character(gg$소유구분)
gg$소유권변동일자 <- as.Date(gg$소유권변동일자)

#새로운 열(변수) 생성, cha를 지번과 결합, paste0는 공백없이 이어붙이는 경우
gg$주소 <- with(gg, paste0(법정동명," ",지번))

#제대로 결합되었는지 확인
head(gg)

#시점 및 소유구분 필터링하기
gg2 <- filter(gg, 소유권변동일자 < "2017-03-23", 소유구분 == "개인")
gg3 <- select(gg2, 토지면적, 공시지가, 소유구분, 소유권변동원인, 공유인수, 공유인일련번호, 소유권변동일자, 주소)

#조이닝할 샘플 csv 불러들이기
sample <- read.csv("gyeonggi_sample.csv")
head(sample)

#dplyr 패키지의 left_join 함수 사용시
gg_left <- left_join(sample, gg3, by = "주소")

#특정 열 기준으로 정렬하기, arrange 쓸 땐 메모리 과부하걸리니 필터링 하고 쓰는 것으로
arrange(gg_left, desc(소유권변동일자)) #(변수이름, 해당 열, 내림차순할 시에는 해당열 앞에 desc()를 붙여주기)
head(gg_left)
tail(gg_left)

#생성된 결합테이블 내보내기
write.csv(gg_left, file="1121_gg_left.csv", row.names = TRUE)
write.csv(gg3, file="1121_gg3.csv", row.names = TRUE)

#특정 키워드의 변수들만 추출하고 싶을 때
gg_ext <- subset(gg2, 주소 == "경기도 김포시 통진읍 귀전리 169-4")
gg_ext

