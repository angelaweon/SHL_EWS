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
                                 식사시작일자, 식사명, 금식구분명)) %>% unique()
names(nur2)

# 데이터 확인
addmargins(table(nur2$음주구분))
addmargins(table(nur2$흡연구분))
addmargins(table(nur2$타병원입원여부))
addmargins(table(nur2$식욕상태))
addmargins(table(nur2$체중변화유무))
addmargins(table(nur2$수면장애유무))
addmargins(table(nur2$활동정도))
addmargins(table(nur2$의식상태))
addmargins(table(nur2$지남력_사람))
addmargins(table(nur2$지남력_시간))
addmargins(table(nur2$지남력_장소))


# y/n 데이터 0, 1로 바꾸기
nur3 <- nur2 %>% mutate(사망여부 = ifelse(is.na(사망여부), 0, 1),
                        Insight병식유무 = ifelse(Insight병식유무 == 'N', 0, 
                                             ifelse(Insight병식유무 == 'Y', 1, NA)),
                        과거력유무 = ifelse(과거력유무 == 'N', 0,
                                       ifelse(과거력유무 == 'Y', 1, NA)),
                        과거력고혈압 = ifelse(과거력고혈압 == 'N', 0,
                                       ifelse(과거력고혈압 == 'Y', 1, NA)),
                        과거력당뇨 = ifelse(과거력당뇨 == 'N', 0,
                                       ifelse(과거력당뇨 == 'Y', 1, NA)),
                        과거력결핵 = ifelse(과거력결핵 == 'N', 0,
                                       ifelse(과거력결핵 == 'Y', 1, NA)),
                        과거력간염 = ifelse(과거력간염 == 'N', 0,
                                       ifelse(과거력간염 == 'Y', 1, NA)),
                        과거력기타유무 = ifelse(과거력기타유무 == 'N', 0,
                                       ifelse(과거력기타유무 == 'Y', 1, NA)),
                        알러지여부 = ifelse(알러지여부 == 'N', 0,
                                       ifelse(알러지여부 == 'Y', 1, NA)),
                        타병원입원여부 = ifelse(타병원입원여부 == 'N', 0,
                                         ifelse(타병원입원여부 == 'Y', 1, NA)),
                        체중변화유무 = ifelse(체중변화유무 == 'N', 0,
                                        ifelse(체중변화유무 == 'Y', 1, NA)),
                        수면장애유무 = ifelse(수면장애유무 == 'N', 0,
                                        ifelse(수면장애유무 == 'Y', 1, NA)))

df_nurse <- nur3

# 저장
save(df_nurse, file = 'C:/Yong/ews/hackathon/csv80000/rdata/간호초기.RData')
