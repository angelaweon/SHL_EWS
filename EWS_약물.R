# rm(list = ls())
# package
library(dplyr)
library(data.table)

# 데이터 불러오기
med <- fread('C:/Yong/ews/hackathon/csv80000/med.csv', stringsAsFactors = F,
             na.strings = c('', NA))

# 환자별 입원일자별 변수 나열

# 각 약물별로 변수 생성
names(med)

med2 <- med %>% dplyr::mutate(meropenem = ifelse(처방코드 %in% c('XMERO'), 1, 0),
                              vancomycin = ifelse(처방코드 %in% c('XVACP', 'XVACP1',
                                                              'XVANC', 'XVANC1'), 1, 0),
                              caspofungin = ifelse(처방코드 %in% c('XCAFU5', 'XCAFU7'), 1, 0),
                              norepinephrine = ifelse(처방코드 %in% c('XNOR10', 'XNOR20'), 1, 0),
                              vasopressin = ifelse(처방코드 %in% c('XVASO'), 1, 0),
                              dopamine = ifelse(처방코드 %in% c('XDOPA', 'XDOPA2', 'XDOPA4',
                                                            'XDP2D2', 'XDP2D20', 'XDP4D2',
                                                            'XDP4D20', 'XDP4D5', 'XDP8D5'), 1, 0),
                              morphinesulfate = ifelse(처방코드 %in% c('XMS10', 'XMS30',
                                                                   'XMS100'), 1, 0),
                              fentanyl = ifelse(처방코드 %in% c('XFENT', 'XFENT5', 'XFENT15'), 1, 0))

# 총용량, 총용량단위, 횟수, 일수 ??

# 저장
save(med2, file = 'C:/Yong/ews/hackathon/csv80000/rdata/약물.RData')
