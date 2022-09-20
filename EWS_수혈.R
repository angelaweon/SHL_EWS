# rm(list = ls())
# package
library(dplyr)
library(data.table)
library(lubridate)

# 데이터 불러오기
blood <- fread('C:/Yong/ews/hackathon/csv80000/blood.csv', stringsAsFactors = F,
              na.strings = c('', NA))

# 환자별 입원일자별 변수 나열(여러번 측정하면 평균값)

names(blood)

blood <- blood %>% arrange(환자일련번호, 수혈시작일시)

# 출혈환자 정의 : 적혈구 수혈 시작 후 24시간 이내 적혈구 수혈을 또 시작한 환자

# 수혈 받은 시각 - 수혈 팩 양으로 데이터셋 만들기

# 시간 단위로 바꾸기
blood2 <- blood %>% mutate(수혈일자 = 
                           paste0(substr(수혈시작일시, 3, 4), substr(수혈시작일시, 6, 7),
                                  substr(수혈시작일시, 9, 10)) %>% ymd(),
                         수혈시간 = ifelse(substr(수혈시작일시, 15, 16) != '00' |
                                           substr(수혈시작일시, 12, 16) == '00:00',
                                         substr(수혈시작일시, 12, 13) %>% as.numeric() + 1,
                                         ifelse(substr(수혈시작일시, 15, 16) == '00',
                                                substr(수혈시작일시, 12, 13) %>% as.numeric(), NA)))


blood3 <- blood2 %>% group_by(환자일련번호, 입원일자, 퇴원일자, 수혈일자, 수혈시간) %>%
  summarise(수량 = sum(사용수량))

df_blood <- blood3

# 저장
save(df_blood, file = 'C:/Yong/ews/hackathon/csv80000/rdata/수혈.RData')
