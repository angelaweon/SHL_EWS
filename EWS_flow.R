# rm(list = ls())
# package
library(dplyr)
library(data.table)
library(lubridate)

# 데이터 불러오기
flow <- fread('C:/Yong/ews/hackathon/csv80000/flow.csv', stringsAsFactors = F,
             na.strings = c('', NA))

# 환자별 입원일자별 변수 나열(여러번 측정하면 평균값)

# flow 시간
# 시간 단위로 바꾸기
names(flow)
flow2 <- flow %>% mutate(항목기록일자 = 
                           paste0(substr(항목기록일시, 3, 4), substr(항목기록일시, 6, 7),
                                  substr(항목기록일시, 9, 10)) %>% ymd(),
                         항목기록시간 = ifelse(substr(항목기록일시, 15, 16) != '00' |
                                           substr(항목기록일시, 12, 16) == '00:00',
                                         substr(항목기록일시, 12, 13) %>% as.numeric() + 1,
                                         ifelse(substr(항목기록일시, 15, 16) == '00',
                                                substr(항목기록일시, 12, 13) %>% as.numeric(), NA)))
save(flow2, file = 'C:/Yong/ews/hackathon/csv80000/rdata/flow시간까지.RData')

load('C:/Yong/ews/hackathon/csv80000/rdata/flow시간까지.RData')



# spo2
spo2 <- flow2 %>% filter(항목 %in% c('177','178','179',
                               '180','2729','105'))
spo2$항목기록값 <- as.numeric(spo2$항목기록값)

spo2 <- spo2 %>% mutate(spo2 = ifelse(항목기록값 <= 100, 항목기록값, NA)) %>% 
  dplyr::select(환자일련번호, 입원일자, 항목기록일자, 항목기록시간, spo2) %>% na.omit()

# nibp수축
nibp_sys <- flow2 %>% filter(항목 %in% c('166'))
nibp_sys$항목기록값 <- as.numeric(nibp_sys$항목기록값)

nibp_sys <- nibp_sys %>% mutate(nibp_sys = 항목기록값) %>%
  dplyr::select(환자일련번호, 입원일자, 항목기록일자, 항목기록시간, nibp_sys) %>% na.omit()

# nibp이완
nibp_dia <- flow2 %>% filter(항목 %in% c('164'))
nibp_dia$항목기록값 <- as.numeric(nibp_dia$항목기록값)

nibp_dia <- nibp_dia %>% mutate(nibp_dia = 항목기록값) %>% 
  dplyr::select(환자일련번호, 입원일자, 항목기록일자, 항목기록시간, nibp_dia) %>% na.omit()

# nibp평균
nibp_mean <- flow2 %>% filter(항목 %in% c('165'))
nibp_mean$항목기록값 <- as.numeric(nibp_mean$항목기록값)

nibp_mean <- nibp_mean %>% mutate(nibp_mean = 항목기록값) %>% 
  dplyr::select(환자일련번호, 입원일자, 항목기록일자, 항목기록시간, nibp_mean) %>% na.omit()

# pr
pr <- flow2 %>% filter(항목 %in% c('171'))
pr$항목기록값 <- as.numeric(pr$항목기록값)

pr <- pr %>% mutate(pr = 항목기록값) %>% 
  dplyr::select(환자일련번호, 입원일자, 항목기록일자, 항목기록시간, pr) %>% na.omit()

# hr
hr <- flow2 %>% filter(항목 %in% c('160'))
hr$항목기록값 <- as.numeric(hr$항목기록값)

hr <- hr %>% mutate(hr = 항목기록값) %>% 
  dplyr::select(환자일련번호, 입원일자, 항목기록일자, 항목기록시간, hr) %>% na.omit()

# rr
rr <- flow2 %>% filter(항목 %in% c('174','1081','1184'))
rr$항목기록값 <- as.numeric(rr$항목기록값)

rr <- rr %>% mutate(rr = 항목기록값) %>% 
  dplyr::select(환자일련번호, 입원일자, 항목기록일자, 항목기록시간, rr) %>% na.omit()

# bt
bt <- flow2 %>% filter(항목 %in% c('182','183','184','186',
                                 '187','188','190','191',
                                 '185','189','192','2687'))
bt$항목기록값 <- as.numeric(bt$항목기록값)

bt <- bt %>% mutate(bt = 항목기록값) %>% 
  dplyr::select(환자일련번호, 입원일자, 항목기록일자, 항목기록시간, bt) %>% na.omit()

# avpu
avpu <- flow2 %>% filter(항목 %in% c('1394'))
addmargins(table(avpu$항목기록값))

avpu <- avpu %>% na.omit()

# oxygen therapy-device
ot_device <- flow2 %>% filter(항목 %in% c('115'))

addmargins(table(ot_device$항목기록값))

# oxygen therapy-Fio2
ot_fio2 <- flow2 %>% filter(항목 %in% c('116'))

addmargins(table(ot_fio2$항목기록값))

# oxygen therapy-o2flow
ot_o2flow <- flow2 %>% filter(항목 %in% c('117'))

addmargins(table(ot_o2flow$항목기록값))

# I/O
io_code <- fread('C:/Yong/ews/hackathon/io_code.csv', encoding = 'UTF-8',
                 stringsAsFactors = F, na.strings = c('', NA), )

# Intake 전체
intake <- flow2 %>% filter(항목 %in% io_code$intake[!is.na(io_code$intake)])
table(intake$항목기록값)

a <- intake %>% group_by(항목그룹, 항목그룹명, 항목, 항목명) %>% summarise(n = n())
fwrite(a, file = 'C:/Yong/ews/hackathon/intake.csv', bom = T)

# Output 전체
output <- flow2 %>% filter(항목 %in% io_code$output[!is.na(io_code$output)])
table(output$항목기록값)

a <- output %>% group_by(항목그룹, 항목그룹명, 항목, 항목명) %>% summarise(n = n())
fwrite(a, file = 'C:/Yong/ews/hackathon/output.csv', bom = T)

# Net Balance
netbal <- flow2 %>% filter(항목 %in% c('211'))
summary(as.numeric(netbal$항목기록값))

# 혈액-SDP
sdp <- flow2 %>% filter(항목 %in% c('1298','2641'))


# 혈액-FFP

# 혈액-cryo

# 혈액-LD-PC

# 혈액-LD-RBC

# Urine합계

# Stool(회)

# Stool(합계)

# Foley

# 붙이기
# flow2 에서 환자일련번호, 입원일자, 항목기록일자, 항목기록시간 -> 중복제거
flow_pt <- flow2 %>% dplyr::select(환자일련번호, 입원일자, 항목기록일자, 항목기록시간)
flow_pt <- flow_pt[!duplicated(flow_pt),] %>% na.omit() %>%
  arrange(환자일련번호, 입원일자, 항목기록일자, 항목기록시간)

# 하나씩 붙이기
