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

smart2 <- smart %>% mutate(smart팀일자 = 
                             paste0(substr(smart팀일시, 3, 4), substr(smart팀일시, 6, 7),
                                    substr(smart팀일시, 9, 10)) %>% as.numeric() %>% ymd(),
                           smart팀시간 = ifelse(substr(smart팀일시, 15, 16) != '00' |
                                               substr(smart팀일시, 12, 16) == '00:00',
                                             substr(smart팀일시, 12, 13) %>% as.numeric() + 1,
                                             ifelse(substr(smart팀일시, 15, 16) == '00',
                                             substr(smart팀일시, 12, 13) %>% as.numeric(), NA)))

a <- smart2 %>% filter(substr(smart팀일시, 15, 16) == '00')
# 저장
save(smart2, file = 'C:/Yong/ews/hackathon/csv80000/rdata/smart팀여.RData')

