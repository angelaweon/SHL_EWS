# rm(list = ls())
# package
library(dplyr)
library(data.table)

# 데이터 불러오기
adr <- fread('C:/Yong/ews/hackathon/csv80000/adr.csv', stringsAsFactors = F,
             na.strings = c('', NA))

# 환자별 입원일자별 변수 나열

# 각 약물별로 변수 생성
names(adr)
df_adr <- adr %>% mutate(약물이상반응여부 = ifelse(is.na(약물이상반응여부), 0, 1))

# 저장
save(adr, file = 'C:/Yong/ews/hackathon/csv80000/rdata/약물이상반응.RData')


