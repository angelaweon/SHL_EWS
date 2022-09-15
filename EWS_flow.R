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
head(flow2, 10)
a <- flow2 %>% filter(substr(항목기록일시, 12, 16) == '00:00')
flow2 <- flow %>% mutate(항목기록일자 = 
                           paste0(substr(항목기록일시, 3, 4), substr(항목기록일시, 6, 7),
                                  substr(항목기록일시, 9, 10)) %>% as.numeric() %>% ymd(),
                         항목기록시간 = ifelse(substr(항목기록일시, 15, 16) != '00' |
                                           substr(항목기록일시, 12, 16) == '00:00',
                                         substr(항목기록일시, 12, 13) %>% as.numeric() + 1,
                                         ifelse(substr(항목기록일시, 15, 16) == '00',
                                                substr(항목기록일시, 12, 13) %>% as.numeric(), NA)))
save(flow2, file = 'C:/Yong/ews/hackathon/csv80000/rdata/flow시간까지.RData')
rm(flow)

# spo2
spo2 <- flow2 %>% filter(항목 %in% c('177','178','179',
                               '180','2729','105'))
spo2$항목기록값 <- as.numeric(spo2$항목기록값)

spo2 <- spo2 %>% mutate(spo2 = ifelse(항목기록값 <= 100, 항목기록값, NA)) %>% 
  dplyr::select(환자일련번호, 항목기록일자, 항목기록시간, spo2) %>% na.omit()

# nibp수축
nibp_sys <- flow2 %>% filter(항목 %in% c('166'))
nibp_sys$항목기록값 <- as.numeric(nibp_sys$항목기록값)

nibp_sys <- nibp_sys %>% mutate(nibp_sys = 항목기록값) %>%
  dplyr::select(환자일련번호, 항목기록일자, 항목기록시간, nibp_sys) %>% na.omit()

# nibp이완
nibp_dia <- flow2 %>% filter(항목 %in% c('164'))
nibp_dia$항목기록값 <- as.numeric(nibp_dia$항목기록값)

nibp_dia <- nibp_dia %>% mutate(nibp_dia = 항목기록값) %>% 
  dplyr::select(환자일련번호, 항목기록일자, 항목기록시간, nibp_dia) %>% na.omit()

# nibp평균
nibp_mean <- flow2 %>% filter(항목 %in% c('165'))
nibp_mean$항목기록값 <- as.numeric(nibp_mean$항목기록값)

nibp_mean <- nibp_mean %>% mutate(nibp_mean = 항목기록값) %>% 
  dplyr::select(환자일련번호, 항목기록일자, 항목기록시간, nibp_mean) %>% na.omit()

# pr
pr <- flow2 %>% filter(항목 %in% c('171'))
pr$항목기록값 <- as.numeric(pr$항목기록값)

pr <- pr %>% mutate(pr = 항목기록값) %>% 
  dplyr::select(환자일련번호, 항목기록일자, 항목기록시간, pr) %>% na.omit()

# hr
hr <- flow2 %>% filter(항목 %in% c('160'))
hr$항목기록값 <- as.numeric(hr$항목기록값)

hr <- hr %>% mutate(hr = 항목기록값) %>% 
  dplyr::select(환자일련번호, 항목기록일자, 항목기록시간, hr) %>% na.omit()

# rr
rr <- flow2 %>% filter(항목 %in% c('174','1081','1184'))
rr$항목기록값 <- as.numeric(rr$항목기록값)

rr <- rr %>% mutate(rr = 항목기록값) %>% 
  dplyr::select(환자일련번호, 항목기록일자, 항목기록시간, rr) %>% na.omit()

# bt
bt <- flow2 %>% filter(항목 %in% c('182','183','184','186',
                                 '187','188','190','191',
                                 '185','189','192','2687'))
bt$항목기록값 <- as.numeric(bt$항목기록값)

bt <- bt %>% mutate(bt = 항목기록값) %>% 
  dplyr::select(환자일련번호, 항목기록일자, 항목기록시간, bt) %>% na.omit()

# avpu
avpu <- flow2 %>% filter(항목 %in% c('174','1081','1184'))

# oxygen therapy-device


# 샘플
s_flow2 <- flow %>% filter(환자일련번호 < 100)
# s_flow2 <- s_flow2 %>% mutate(항목기록일자 = 
#                                 paste0(substr(항목기록일시, 3, 4), substr(항목기록일시, 6, 7),
#                                        substr(항목기록일시, 9, 10)) %>% as.numeric() %>% ymd(),
#                               항목기록시간 = ifelse(substr(항목기록일시, 15, 16) != '00' |
#                                              substr(항목기록일시, 12, 16) == '00:00',
#                                            substr(항목기록일시, 12, 13) %>% as.numeric() + 1,
#                                            ifelse(substr(항목기록일시, 15, 16) == '00',
#                                                   substr(항목기록일시, 12, 13) %>% as.numeric(), NA)))
s_flow3a <- s_flow3 %>% filter(항목 %in% c('177','178','179',
                                         '180','2729','105'))
table(s_flow3$spo2)


# 
# s_flow3 <- s_flow2 %>% mutate(spo2 = ifelse(항목 %in% c('177','178','179',
#                                                       '180','2729','105') &
#                                               as.numeric(항목기록값) <= 100,
#                                             as.numeric(항목기록값), NA))
# nibp수축 = ifelse(항목 %in% c('166'), 항목기록값, NA),
# nibp이완 = ifelse(항목 %in% c('164'), 항목기록값, NA),
# nibp평균 = ifelse(항목 %in% c('165'), 항목기록값, NA),
# pr = ifelse(항목 %in% c('171'), 항목기록값, NA),
# hr = ifelse(항목 %in% c('160'), 항목기록값, NA),
# rr = ifelse(항목 %in% c('174','1081','1184'), 항목기록값, NA),
# bt = ifelse(항목 %in% c('182','183','186','187',
#                       '188','191','184','190',
#                       '185','189','192','2687'), 항목기록값, NA),
# avpu = ifelse(항목 %in% c('1394'), 항목기록값, NA),
# ot_device = ifelse(항목 %in% c('115'), 항목기록값, NA),
# ot_fio2 = ifelse(항목 %in% c('116'), 항목기록값, NA),
# ot_o2flow = ifelse(항목 %in% c('117'), 항목기록값, NA),
# intake = ifelse(항목 %in% c(), 항목기록값, NA),
# output = ifelse(항목 %in% c(), 항목기록값, NA),
# netbalance = ifelse(항목 %in% c(211), 항목기록값, NA),
# 통증여부 = ifelse(항목 %in% c(), 항목기록값, NA),
# 통증척도 = ifelse(항목 %in% c(), 항목기록값, NA),
# 통증점수 = ifelse(항목 %in% c(), 항목기록값, NA),
# 병동시행중심정맥관 = ifelse(항목 %in% c(), 항목기록값, NA),
# foley = ifelse(항목 %in% c(), 항목기록값, NA),
# picc = ifelse(항목 %in% c(), 항목기록값, NA))






# 저장

