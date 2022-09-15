# rm(list = ls())
# package
library(dplyr)
library(data.table)

# 데이터 불러오기
nur <- fread('C:/Yong/ews/hackathon/csv80000/pa.csv', stringsAsFactors = F,
             na.strings = c('', NA))

# 환자별 입원일자별 변수 나열


# 환자정보, 간호초기평가 변수만 선택
names(nur)
nur2 <- nur %>% dplyr::select(-c(ICU_입실일시, ICU_퇴실일시, 수술코드, 수술명, 
                                 수술일자, 응급수술여부, 수술후환자퇴실일시,
                                 수술후퇴실장소구분명, CPR_발생원내.외구분, CPR_발생일시,
                                 식사시작일자, 식사명, 금식구분명))
nur2 <- nur2[duplicated(nur2) == F,]
names(nur2)

# 저장
save(nur2, file = 'C:/Yong/ews/hackathon/csv80000/rdata/간호초기.RData')
