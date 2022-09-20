# rm(list = ls())
# package
library(dplyr)
library(data.table)
library(lubridate)

# 데이터 불러오기
smart <- fread('C:/Yong/ews/hackathon/csv80000/smart.csv', stringsAsFactors = F,
             na.strings = c('', NA))

# 환자별 입원일자별 변수 나열

# smart팀 출동 시간
# 시간 단위로 바꾸기
names(smart)
table(smart$smart팀여부)
smart2 <- smart %>% mutate(smart팀일자 = 
                             paste0(substr(smart팀일시, 3, 4), substr(smart팀일시, 6, 7),
                                    substr(smart팀일시, 9, 10)) %>% ymd(),
                           smart팀시간 = ifelse(substr(smart팀일시, 15, 16) != '00' |
                                               substr(smart팀일시, 12, 16) == '00:00',
                                             substr(smart팀일시, 12, 13) %>% as.numeric() + 1,
                                             ifelse(substr(smart팀일시, 15, 16) == '00',
                                             substr(smart팀일시, 12, 13) %>% as.numeric(), NA)),
                           smart팀여부 = ifelse(is.na(smart팀여부), 0, 1)) %>%
  dplyr::select(-smart팀일시)

df_smart <- smart2

# 저장
save(df_smart, file = 'C:/Yong/ews/hackathon/csv80000/rdata/smart팀여부.RData')

