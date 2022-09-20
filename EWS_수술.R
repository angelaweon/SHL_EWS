# rm(list = ls())
# package
library(dplyr)
library(data.table)
library(lubridate)

# 데이터 불러오기
op <- fread('C:/Yong/ews/hackathon/csv80000/pa.csv', stringsAsFactors = F,
              na.strings = c('', NA))

# 환자별 입원일자별 변수 나열(여러번 측정하면 평균값)

names(op)
op <- op %>% mutate(수술여부 = ifelse(is.na(수술일자) == F, 1, 0))
op <- op %>% dplyr::select(환자일련번호, 입원일자, 퇴원일자, 수술일자, 수술여부, 응급수술여부,
                           수술후환자퇴실일시, 수술후퇴실장소구분명) %>% unique() %>%
  arrange(환자일련번호, 입원일자, 수술일자)

# 시간 단위로 바꾸기
op2 <- op %>% mutate(수술후퇴실일자 = 
                           paste0(substr(수술후환자퇴실일시, 3, 4), substr(수술후환자퇴실일시, 6, 7),
                                  substr(수술후환자퇴실일시, 9, 10)) %>% ymd(),
                         수술후퇴실시간 = ifelse(substr(수술후환자퇴실일시, 15, 16) != '00' |
                                           substr(수술후환자퇴실일시, 12, 16) == '00:00',
                                         substr(수술후환자퇴실일시, 12, 13) %>% as.numeric() + 1,
                                         ifelse(substr(수술후환자퇴실일시, 15, 16) == '00',
                                                substr(수술후환자퇴실일시, 12, 13) %>% as.numeric(), NA)))

op2 <- op2 %>% dplyr::select(-수술후환자퇴실일시)

op3 <- op2 %>% mutate(응급수술여부2 = ifelse(is.na(응급수술여부) == T, 0, 1)) %>% 
  dplyr::select(-응급수술여부) %>% rename(응급수술여부 = 응급수술여부2)

df_op <- op3

# 저장
save(df_op, file = 'C:/Yong/ews/hackathon/csv80000/rdata/수술.RData')
# load('C:/Yong/ews/hackathon/csv80000/rdata/수술.RData')
