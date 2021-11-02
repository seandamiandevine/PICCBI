library(dplyr); library(reshape2)
library(ggplot2); library(ggpubr)
library(lme4)
library(sjPlot)
setwd("/Users/seandevine/Documents/PICCBI/")
rm(list =ls())

# Load and Clean Data -----------------------------------------------------
d <- readRDS('Raw_PICCBI_DF.rds')
  
# files = list.files(path = 'data/', pattern = '.csv')
# d = data.frame()
# col_names = c()
# rowcount = 1
# for(f in 1:length(files)) {
# 
#   cat(f, '/', length(files), '\n')
#   tmp = read.csv(paste0('data/', files[f]))
#   tmp$site = ifelse('prolID' %in% names(tmp), 'prolific', 'SONA') # keep track of data origin
# 
#   if(ncol(tmp) == 154 & length(col_names)==0) {
# 
#     col_names = names(tmp)
# 
#   } else {
# 
#     if('sex' %in% names(tmp) == F) tmp$sex = tmp$gender
#     tmp = tmp[names(tmp) %in% col_names]
# 
#       }
# 
#   d <- rbind(d, tmp)
# 
# }
# saveRDS(d, file='Raw_PICCBI_DF.rds')

# CLEAN BODIES DATA
d = d[d$stimulus!='',]
d$stimulus = lag(d$stimulus)
d = d[is.na(d$trial)==F,]
d$stimulus = sub(".*/", "", d$stimulus)
d$stimulus = sub(".jpg", "", d$stimulus)
d$size = ifelse(substring(d$stimulus, 1, 1) == 'T', 
                300 - as.numeric(substring(d$stimulus, 2, 4)), 
                300 +  as.numeric(substring(d$stimulus, 2, 4)))


# factors where needed
d$block=factor(d$block, levels = 1:16)
d$condition = factor(ifelse(d$condition==1, 'Increase', 'Stable'), levels = c('Stable', 'Increase'))

d = d[is.na(d$block)==F,] # remove practice trials 

# compute useful variables 
d = d %>% group_by(subject) %>%
  mutate(key_press = ifelse(key_press=='65', 0, 1),  # 1 = overweight
         trialnum = 1:length(subject), 
         trial0 = trialnum/max(trialnum), 
         size0 = size/max(size), 
         timebin = as.factor(ntile(trialnum, 4)), 
         age = as.numeric(gsub("([0-9]+).*$", "\\1", age))) %>%
  ungroup() %>% 
  mutate(stimbin = ntile(size, 20))


# Save Demographic Info ---------------------------------------------------
d$sexcode <- ifelse(grepl('female', tolower(d$sex)), 1, 0)

# * Pre-Exclusion ####
demopre = d %>%
  group_by(condition) %>%
  summarise(n = length(unique(subject)), 
            mage = mean(age, na.rm = T), 
            sage = sd(age, na.rm = T), 
            pfemale = mean(sexcode,na.rm=T))

# * Exclude ####
badsubjects <- c('q4758ogyy5oyy6q','ehdlzjl5vh4ln87', 'ay6n6kdz1bsd52h', 'ohkm9vdkst3zghh', 
                 'x5qje3v52jfzumf') # see subject curves 
d = d %>% filter(!subject %in% badsubjects,
                 age <= 30 | is.na(age), # exclude anyone older than 30
                 sexcode == 1, # exclude men and others
                 tolower(mentdrug) %in% c('no', NA, 'n/a', 'na', 'none', 'n/a.', 'n\\a'), # exclude anyone with current or past mental health issues
                 !subject %in% (d %>% group_by(subject) %>%  # exclude subjects with rts > 7 s on +10 trials
                                  mutate(rt = as.numeric(as.character(rt))) %>%
                                  summarise(rt.1 = sum(rt <= 100), 
                                            rt7 = sum(rt >= 7000)) %>%
                                  filter(rt7 > 10 ))$subject,
                 catch2 == 1,
                 catch1 == 2,
                 catch3 == 0)

# remove subjects who didn't finish task
d = d[d$subject %in% (d %>% group_by(subject) %>% summarise(mtrial = max(trialnum)) %>% 
                        filter(mtrial==800))$subject, ]

# * Post-Exclusion ####
demopost = d %>%
  group_by(condition) %>%
  mutate(age = as.numeric(age)) %>% 
  summarise(n = length(unique(subject)), 
            mage = mean(age, na.rm = T), 
            sage = sd(age, na.rm = T), 
            pfemale = mean(sexcode))
N = sum(demopost$n)

# remove super fast or super slow responses (optional) 
# d = d %>% mutate(rt = as.numeric(as.character(rt))) %>% filter(rt <=7000)

# Subset Data -------------------------------------------------------------

# * Save Questionnaire Data ####
q = d %>% select(everything(), -c(trial_type, trial_index, time_elapsed, internal_node_id, rt, url, 
                 success, view_history, responses, question_order, final_value, start_value, stimulus, 
                 key_press, trial, block, freq, s1self, chosenbody, s1selfjudge, s2selfjudge, s2self)) %>% 
  group_by(subject) %>% 
  filter(row_number(subject) == 1) %>% 
  ungroup()

# * Keep Relevant Data ####
d = d %>% select(subject, condition, sex, age, chosenbody, s1self, s1selfjudge, s2selfjudge, s2self, 
                 block, trial, stimulus, key_press, rt, freq, time_elapsed, size, trialnum, trial0, size0, 
                 timebin, stimbin, site)


# Sanity Checks -----------------------------------------------------------
# Check if sizes follow appropriate pattern based on condition 
sanitycheckplot <- 
  d %>% 
  filter(is.na(block)==F) %>% 
  group_by(condition, trialnum) %>% 
  summarise(size = mean(size)) %>% 
  ggplot(aes(x=trialnum, y=size, colour=condition, group=condition)) + 
  geom_point() + 
  geom_line() +
  #geom_smooth(size = 2) + 
  scale_y_continuous(breaks = c(125, 375), labels = c('Thinner', 'Heavier'), 
                     limits = c(125, 375)) + 
  scale_colour_manual(values=c("#0066CC", '#990000')) +
  labs(x = 'Trial', y='Average Model Size', colour='Prevalence' ) + 
  theme_bw()
  
# BMI vs. Chosen model 
bmi <- full_join(q[, c('subject', 'weight', 'height')],
                 d[, c('subject', 's1self', 's2self', 's1selfjudge', 's2selfjudge')]) %>% 
  group_by(subject) %>% 
  slice(1)

kg <- c()
for(weight in 1:length(bmi$weight)) {
  if(grepl(',', bmi$weight[weight])) bmi$weight[weight] = gsub(',','.', bmi$weight[weight])
  
  if(is.na(bmi$weight[weight])) {
    kg[weight] = NA
  } else if(grepl('stone', bmi$weight[weight])){
            kg[weight] = as.numeric(gsub('\\D+', '', bmi$weight[weight])) * 6.35029
  } else if(grepl('kg', tolower(bmi$weight[weight]))){
    kg[weight] =  as.numeric(gsub('\\D+', '', bmi$weight[weight]))
  } else if(grepl('lb', bmi$weight[weight])) {
    kg[weight] = as.numeric(gsub('[a-zA-Z]', '', bmi$weight[weight])) * 0.453592
  } else if(as.numeric(bmi$weight[weight]) < 90){
    kg[weight] = as.numeric(bmi$weight[weight])
  } else {
    kg[weight] = as.numeric(bmi$weight[weight]) * 0.453592
  }
}

meters <- c()
for(m in 1:length(bmi$height)) {
  thisheight = bmi$height[m]
  thisheight = gsub('\'', '.', thisheight)
  thisheight = gsub('foot', '.', thisheight)
  thisheight = gsub('inches', '', thisheight)
  thisheight = gsub('meters', '', thisheight)
  thisheight = gsub(',', '.', thisheight)
  if(grepl('cm', thisheight)) {
    thisheight = as.numeric(gsub('[a-zA-Z ]', '', thisheight))
    meters[m] = thisheight/100
    next
  } else if(grepl(' m', thisheight)) {
    thisheight = as.numeric(gsub('[a-zA-Z ]', '', thisheight))
    meters[m] = thisheight
    next
  }
  
  feet <- as.numeric(strsplit(thisheight, split= '[.]')[[1]][1])
  if(length(strsplit(thisheight, split= '[.]')[[1]]) == 1) {
    inches = 0
  } else {
    inches <- as.numeric(strsplit(thisheight, split= '[.]')[[1]][2])
  }
  meters[m] = feet*0.3048 + inches*0.0254
  if(meters[m] < 1 | meters[m] > 2.25) meters[m] = NA
  #if(is.na(meters[m])) break
}

bmi$bmi <- kg/(meters^2)
cor.test(bmi$bmi, bmi$s1self)

# Model Judgements  ----------------------------------------------------------
# * Visualise #### 
# normal way (Levari et al., 2018; Devine et al., 2021)
piccplot1 <- 
  d %>% 
  group_by(condition, size, timebin) %>% 
  summarise(pFat = mean(key_press)) %>%
  filter(timebin == 1 | timebin == 4) %>% 
  ggplot(aes(x = size, y = pFat, color = timebin)) + geom_point() + 
  geom_line(stat="smooth",method = "glm", method.args = list(
    family="binomial"), se=FALSE,size=1.8,alpha=.7) + 
  ylab('% Models Judged as Overweight') + xlab('') +
  scale_colour_manual(labels=c("Initial 200 trials", "Final 200 trials"), name=NULL,values=c("#0066CC", '#990000')) +
  scale_y_continuous(labels = scales::percent) +
  scale_x_continuous(breaks = c(20, 520), 
                     labels = c('Very Thin', 'Very Overweight')) + 
  theme_bw() + 
  ylim(c(0.00, 1.00)) + 
  facet_wrap(~ condition) + 
  theme(axis.ticks.x = element_blank(), plot.title = element_text(hjust = 0.5), 
        axis.text.y = element_text(size = 10),
        axis.text.x = element_text(size = 10, colour = 'black'), 
        axis.title.y = element_text(size = 12), 
        strip.text = element_text(size = 12)) 

# Visualise another way 
piccplot2 <- 
  d %>% 
  group_by(subject, condition, size, timebin) %>% 
  summarise(pFat = mean(key_press)) %>%
  filter(timebin == 1 | timebin == 4) %>% 
  summarise(change = pFat[timebin==4] - pFat[timebin==1]) %>% 
  ggplot(aes(x = size, y = change, color = condition)) + 
  stat_summary(fun.y = mean, geom = 'point', position = position_dodge(0.9), alpha=0.5) + 
  stat_summary(fun.data = mean_se, geom = 'errorbar', position = position_dodge(0.9), alpha=0.5) + 
  stat_summary(fun.y = mean, geom = 'line', position = position_dodge(0.9)) + 
  scale_y_continuous(labels = scales::percent) +
  scale_x_continuous(breaks = c(0, 600), 
                     labels = c('Very Thin', 'Very Overweight')) + 
  scale_colour_manual(values=c("#0066CC", '#990000')) +
  labs(x = '', 
       y = '% Change in Overweight Judgements\n(Last 200 Trials \u2013 First 200 Trials)', 
       colour = 'Condition') + 
  geom_hline(yintercept = 0) + 
  theme_classic()

# * Analyse ####
# m6 may not converge: use allFit(m4) to find best optimizer
# m6_af <- allFit(m4)

d$size0c = d$size0 - .5
d$conditionc = ifelse(d$condition=='Increase',1,-1)

glm0 <- glm(key_press ~ 1, family = 'binomial', data=d)
m0 <- glmer(key_press ~ 1 + (1|subject), family='binomial', data=d)
m1 <- glmer(key_press ~ 1 + (trial0|subject), family='binomial', data=d)
m2 <- glmer(key_press ~ size0c + (trial0|subject), family='binomial', data=d)
m3 <- glmer(key_press ~ trial0+size0c + (trial0|subject), family='binomial', data=d)
m4 <- glmer(key_press ~ trial0*size0c + (trial0|subject), family='binomial', data=d)
m5 <- glmer(key_press ~ conditionc+trial0*size0c + (trial0|subject), family='binomial', glmerControl(optimizer = 'bobyqa'), data=d)
m6 <- glmer(key_press ~ conditionc*trial0*size0c + (trial0|subject), family='binomial', glmerControl(optimizer = 'bobyqa'), data=d)

anova(m6, m5, m4, m3, m2, m1, m0)
anova(m3, m6)
# anova(m3, m6)$`Pr(>Chisq)`              # for exact pvalue
# summary(m6)$coefficients[, 'Pr(>|z|)']  # for exact pvalue
tab_model(m6, 
          pred.labels = c('Intercept', 'Condition', 'Trial0', 'Size0', 
                          'Condition \u00D7 Trial0',
                          'Condition \u00D7 Size0',
                          'Trial0 \u00D7 Size0', 
                          'Condition \u00D7 Trial0 \u00D7 Size0'), 
          dv.labels = 'Response\n(1 = Overweight)')

# Extract ranefs 
raneffs <- 
  coef(m6)$subject %>% 
  mutate(subject = rownames(.), 
         condition = sapply(unique(d$subject),
                            function(x)
                              .[.$id==x,'condition'] = unique(d$condition[d$subject==x]))) %>%
  select(subject, condition, trial0) 

# show main effect through raneffs
raneffs %>%
  mutate(OR = exp(trial0)) %>%
  ggplot(aes(x = condition, y = OR)) +
  stat_summary(fun.y=mean, geom='bar') +
  stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.2) +
  #coord_cartesian(ylim = c(0.8, 1.3)) +
  labs(x = 'Condition', y = expression(e^hat("\u03B2")['trial0 id']^"EB"), title='Empirical Bayes Estimates for\nTrial0 slopes') +
  theme_bw()

# Self-Judgements ---------------------------------------------------------
# * Visualise ####
cat_plot <- 
  d %>% 
  select(subject, condition, s1selfjudge, s2selfjudge) %>% 
    mutate(s1selfjudge = ifelse(s1selfjudge=='65', 0, 1), 
           s2selfjudge = ifelse(s2selfjudge=='65', 0, 1)) %>% 
    melt(id.vars = c('subject', 'condition')) %>%
    mutate(variable = recode_factor(as.factor(variable), 's1selfjudge' = 'Pre-Task', 's2selfjudge' = 'Post-Task')) %>%
    group_by(subject, variable) %>% 
    slice(1) %>% 
    ggplot(aes(x = condition, y = value, fill=variable)) + 
    stat_summary(fun.y=mean, geom='bar', position=position_dodge(width=0.95)) + 
    stat_summary(fun.data = mean_se, geom = "errorbar", position = position_dodge(width=0.95), width = 0.2) +
    scale_fill_brewer(palette = 'Dark2') + 
    coord_cartesian(ylim=c(0.10, 0.30)) + 
    labs(x = '', y = 'p(Choose Overweight)', fill='', title = 'Change in Self-Concept') + 
    theme_bw() + 
    theme(plot.title = element_text(hjust=0.5),
        plot.tag = element_text(size=20))

cont_plot <- 
  d %>% 
  select(subject, condition, s1self, s2self) %>%
    melt(id.vars=c('subject', 'condition')) %>% 
    mutate(variable = recode_factor(as.factor(variable), 's1self' = 'Pre-Task', 's2self' = 'Post-Task')) %>% 
    group_by(subject, variable) %>% 
    slice(1) %>% 
    ggplot(aes(x = condition, y = value, fill=variable)) + 
    stat_summary(fun.y=mean, geom='bar', position=position_dodge(width=0.95)) + 
    stat_summary(fun.data = mean_se, geom= 'errorbar', position = position_dodge(width=0.95), width=0.2) +  
    coord_cartesian(ylim = c(0.45, 0.55)) + 
    scale_fill_brewer(palette = 'Dark2') +
    labs(x = '', y = 'Mean Size of Chosen Model', 
         fill='', title = 'Change in Self-Image') +
    theme_bw() +
    theme(plot.title = element_text(hjust=0.5), 
          plot.tag = element_text(size=20)) 
  
ggarrange(cat_plot, cont_plot, nrow=1, labels = letters[1:2], 
          common.legend = T, legend = 'bottom')

# * Analyse w/MLM ####
self_fit_data <- 
  d %>% 
  select(subject, condition, s1selfjudge, s2selfjudge, s1self, s2self) %>% 
  mutate(s1selfjudge = ifelse(s1selfjudge=='65', 0, 1), 
         s2selfjudge = ifelse(s2selfjudge=='65', 0, 1)) %>% 
  melt(id.vars = c('subject', 'condition')) %>%
  group_by(subject, condition, variable) %>% 
  slice(1) 

# * * Categorical ####
glm_cat <- glm(value ~ 1, family = 'binomial', data=self_fit_data[self_fit_data$variable %in% c('s1selfjudge', 's2selfjudge'), ])
m0_cat <- glmer(value ~ 1 + (1 | subject), family = 'binomial', data=self_fit_data[self_fit_data$variable %in% c('s1selfjudge', 's2selfjudge'), ])
m1_cat <- glmer(value ~ variable + (1 | subject), family = 'binomial', data=self_fit_data[self_fit_data$variable %in% c('s1selfjudge', 's2selfjudge'), ])
m2_cat <- glmer(value ~ condition + variable + (1 | subject), family = 'binomial', data=self_fit_data[self_fit_data$variable %in% c('s1selfjudge', 's2selfjudge'), ])
m3_cat <- glmer(value ~ condition*variable + (1 | subject), family = 'binomial', data=self_fit_data[self_fit_data$variable %in% c('s1selfjudge', 's2selfjudge'), ])
anova(m3_cat, m2_cat, m1_cat, m0_cat, glm_cat)

# * * Continuous ####
lm_cont <- lm(value ~ 1, data=self_fit_data[self_fit_data$variable %in% c('s1self', 's2self'), ])
m0_cont <- lmer(value ~ 1 + (1 | subject), data=self_fit_data[self_fit_data$variable %in% c('s1self', 's2self'), ])
m1_cont <- lmer(value ~ variable + (1 | subject), data=self_fit_data[self_fit_data$variable %in% c('s1self', 's2self'), ])
m2_cont <- lmer(value ~ condition + variable + (1 | subject), data=self_fit_data[self_fit_data$variable %in% c('s1self', 's2self'), ])
m3_cont <- lmer(value ~ condition * variable + (1 | subject), data=self_fit_data[self_fit_data$variable %in% c('s1self', 's2self'), ])
anova(m3_cont, m2_cont, m1_cont, m0_cont, lm_cont)

car::Anova(m3_cont)

# * Analyse w/o MLM ####
self_dat <- 
  d %>% 
  group_by(subject) %>%
  slice(1) %>% 
  mutate(s1selfjudge = ifelse(s1selfjudge=='65', 0, 1), 
         s2selfjudge = ifelse(s2selfjudge=='65', 0, 1), 
         selfcat = factor(s2selfjudge - s1selfjudge, 
                          levels = c(-1, 0, 1),
                          labels = c('Judged Thinner', 'No Change', 'Judged Heavier')), 
         selfcont = s2self - s1self) %>% 
  select(subject, condition, contains('self'))

# * * Categorical ####
cat.mord0 <- MASS::polr(selfcat ~ 1, data = self_dat, Hess = T)
cat.mord1 <- MASS::polr(selfcat ~ condition, data = self_dat, Hess = T)
cat.mord1.pvals <- pnorm(abs(coef(summary(cat.mord1))[, "t value"]),lower.tail = FALSE)*2
cbind(coef(summary(cat.mord1)), "p" = cat.mord1.pvals)
anova(cat.mord0, cat.mord1)
# predict(object = cat.mord1, data.frame(condition=c('Stable', 'Increase')), type="p")

# * * Continuous ####
cont.m0 <- lm(selfcont ~ 1, data=self_dat)
cont.m1 <- lm(selfcont ~ condition, data=self_dat)
anova(cont.m0, cont.m1)

tab_model(cat.mord1, cont.m1, 
          pred.labels = c('\u03B6 Thinner|No Change', '\u03B6 No Chnage|Heavier', 
                          'Condition', 'Linear Intercept'), 
          dv.labels = c('Categorical Judgements', 'Continuous Judgements'), 
          title = 'Self judgements difference scores.')


# * Relationship Between Model and Self Judgements ####
raneffs_self <- full_join(raneffs, self_dat)

# * * Analyse ####
# Categorical
cat.mord2 <- MASS::polr(selfcat ~ condition+trial0, data = raneffs_self, Hess = T)
cat.mord3 <- MASS::polr(selfcat ~ condition*trial0, data = raneffs_self, Hess = T)
car::Anova(cat.mord3)

#Continuous
cont.m2 <- lm(selfcont ~ trial0+condition, data=raneffs_self)
cont.m3 <- lm(selfcont ~ trial0*condition, data=raneffs_self)
anova(cont.m3)

# * * Visualise ####
raneff_selfjudge_plot <- 
  raneffs_self %>% 
  mutate(ebbin = ifelse(trial0 < 0, 1, 2),  
         ebbin = factor(ifelse(ebbin==1, 'EB < Zero', 'EB > Zero'), 
                        levels = c('EB < Zero', 'EB > Zero'))) %>%
  ungroup() %>% 
  select(subject, condition, ebbin, s1selfjudge, s2selfjudge) %>% 
  melt(id.vars = c('subject', 'condition', 'ebbin')) %>%
  mutate(variable = recode_factor(as.factor(variable), 
                                  's1selfjudge' = 'Pre-Task', 
                                  's2selfjudge' = 'Post-Task')) %>%
  ggplot(aes(x = variable, y = value)) + 
  stat_summary(fun.y=mean, geom='bar', position=position_dodge(width=0.95)) + 
  stat_summary(fun.data = mean_se, geom = "errorbar", position = position_dodge(width=0.95), width = 0.2) +
  facet_grid(~ebbin) +
  coord_cartesian(ylim = c(0.1, 0.3)) +
  labs(x = '', y = 'p(Choose Overweight)', fill='', title = 'Self-Concept') + 
  theme_bw() + 
  theme(plot.title = element_text(hjust=0.5),
        plot.tag = element_text(size=20))

raneff_selfjudge_plot_pred <- 
  plot_model(cat.mord2, type='pred', terms = 'trial0') + 
  labs(x ="EB",
       y = 'Change in Judgement\nPre-Post', 
       title = 'Predicted Probabilities of\nSelf-Concept Change') + 
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5))

raneff_self_plot <- 
  raneffs_self %>% 
  ggplot(aes(x = trial0, y = selfcont, color = condition)) + 
  geom_point(alpha=0.2) + 
  geom_smooth(method = 'lm', se=F, size = 1.5) + 
  labs(x = "EB", y = 'Change in Chosen Model\nPre vs. Post', 
       colour='Condition', title = 'Self-Image') + 
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5))

ggarrange(raneff_self_plot,
          ggarrange(raneff_selfjudge_plot, raneff_selfjudge_plot_pred, nrow=2, labels=letters[2:3]),
          labels=letters[1], 
          common.legend = F, legend='bottom')

# Questionnaire Data ------------------------------------------------------
# * EDEQ ####
edeq <- 
  q %>% 
  select(contains(c('subject', 'EDEQ'))) %>% 
  mutate_at(vars(starts_with("EDEQ")),funs(as.numeric)) %>% 
  mutate(edeq_sum = rowSums(select(., starts_with("EDEQ")), na.rm = TRUE))

# * BSQR ####
bsqr <- 
  q %>% 
  select(contains(c('subject', 'BSQR'))) %>% 
  mutate_at(vars(starts_with("BSQR")),funs(as.numeric)) %>% 
  mutate(bsqr_mean = rowMeans(select(., starts_with("BSQR")), na.rm = TRUE))

# * BSI #### 
bsi <- 
  q %>% 
  select(contains(c('subject', 'BSI'))) %>% 
  mutate_at(vars(starts_with("BSI")),funs(as.numeric)) %>% 
  mutate(bsi_mean = rowMeans(select(., starts_with("BSI")), na.rm = TRUE))

# * NFC #### 
nfc <- 
  q %>% 
  select(contains(c('subject', 'ngs'))) %>% 
  mutate_at(vars(starts_with("ngs")),funs(as.numeric)) %>% 
  mutate(ngs_03 = 4 - ngs_03, 
         ngs_04 = 4 - ngs_04, 
         ngs_05 = 4 - ngs_05,   
         ngs_07 = 4 - ngs_07, 
         ngs_08 = 4 - ngs_08, 
         ngs_09 = 4 - ngs_09, 
         ngs_12 = 4 - ngs_12, 
         ngs_16 = 4 - ngs_16, 
         ngs_17 = 4 - ngs_17) %>% 
  mutate(nfc_sum = rowSums(select(., starts_with("ngs")), na.rm = TRUE))

# * Correlation Plots ####
# * * Model Judgements ####
raneffs_q <- 
  full_join(raneffs, edeq) %>% 
  full_join(., bsqr) %>% 
  full_join(., bsi) %>% 
  full_join(., nfc) %>% 
  select(subject, condition, trial0, contains('sum'), contains('mean')) %>% 
  filter(!is.na(condition))

# * * * Visualise ####
raneffs_q_plot <- 
  raneffs_q %>% 
  melt(id.vars = c('subject', 'condition', 'trial0')) %>% 
  mutate(variable = gsub('_sum', '', variable)) %>% 
  ggplot(aes(x = value, y = trial0, colour=condition)) + 
  geom_point(alpha=0.2) + 
  geom_smooth(method = 'lm', se=F, size = 1.5) + 
  facet_wrap(~variable, scales = 'free') + 
  scale_colour_manual(values=c("#0066CC", '#990000')) +
  labs(x = 'Score', y = expression(hat("\u03B2")['trial0 id']^"EB"),  
       colour='Condition', title = 'Model Judgements\nIn-task') + 
  theme_bw() 

# * * * Analyse ####
raneffs.q.lm <- lm(trial0 ~ edeq_sum + bsqr_mean + bsi_mean, data=raneffs_q)

# * * Self Judgements ####
self_q <- 
  self_dat %>% 
  full_join(., edeq) %>% 
  full_join(., bsqr) %>% 
  full_join(., bsi) %>% 
  full_join(., nfc) %>% 
  select(subject, condition, s1selfjudge, s2selfjudge, selfcat, selfcont,
         contains('sum'), contains('mean'))

# * * * Visualise ####
self_q_plot <- 
  self_q %>% 
  select(everything(), -contains('selfjudge'), -selfcat) %>% 
  melt(id.vars = c('subject', 'condition', 'selfcont')) %>% 
  mutate(variable = gsub('_sum', '', variable)) %>% 
  filter(condition=='Increase') %>% 
  ggplot(aes(x = value, y = selfcont)) + 
  geom_point(alpha=0.2) + 
  geom_smooth(method = 'lm', se=F, size = 1.5) + 
  scale_colour_manual(values=c("#0066CC", '#990000')) +
  facet_wrap(~variable, scales = 'free') + 
  labs(x = 'Score', y = 'Model Size Chosen for Self', 
       colour='Condition', title = 'Self-Judgements\nPost \u2212 Pre') + 
  theme_bw() 

selfjudge_q_plotlist <- list()
qs = c(names(self_q[grepl('sum', names(self_q))]), names(self_q[grepl('mean', names(self_q))]) )
for(i in 1:length(qs)) {
  thisvar = qs[i]
  thisvarname = toupper(gsub('_sum', '', thisvar))
  self_q$bin <- ntile(self_q[, thisvar][[1]], 2)
  
  selfjudge_q_plotlist[[i]] <- 
    self_q %>% 
    mutate(bin = factor(ifelse(bin==1, paste('Low', thisvarname),
                                       paste('High', thisvarname)), 
                          levels = c(paste('Low', thisvarname),
                                     paste('High', thisvarname)))) %>% 
    select(subject, condition, bin, s1selfjudge, s2selfjudge) %>% 
    melt(id.vars = c('subject', 'condition', 'bin')) %>%
    mutate(variable = recode_factor(as.factor(variable), 
                                    's1selfjudge' = 'Pre-Task', 
                                    's2selfjudge' = 'Post-Task')) %>%
    ggplot(aes(x = condition, y = value, fill=variable)) + 
    stat_summary(fun.y=mean, geom='bar', position=position_dodge(width=0.95)) + 
    stat_summary(fun.data = mean_se, geom = "errorbar", position = position_dodge(width=0.95), width = 0.2) +
    facet_grid(~bin) + 
    scale_fill_brewer(palette = 'Dark2') + 
    labs(x = '', y = 'p(Choose Overweight)', fill='') + 
    theme_bw() + 
    theme(plot.title = element_text(hjust=0.5),
          plot.tag = element_text(size=20))
  
}
  
ggarrange(raneffs_q_plot, self_q_plot, labels = letters[1:2], 
          common.legend = T, legend='bottom')

ggarrange(plotlist = selfjudge_q_plotlist, common.legend = T, legend = 'bottom', 
          labels = letters[1:length(qs)])

# * * * Analyse ####
# check scores continuously
cat.mord4 <- MASS::polr(selfcat ~  edeq_sum + bsqr_mean + bsi_mean, data = self_q, Hess = T)
self.q.cont <- lm(selfcont ~ edeq_sum + bsqr_mean + bsi_mean, data=self_q)

tab_model(raneffs.q.lm, self.q.cont, cat.mord4, 
          show.ci = F, show.se = T)

# Misc. 
# check to see if people have backward key mapping 
pdf('misc/subjectcurves.pdf', width = 6.375, 3.01)
for(id in unique(d$subject)) { 
  cat(match(id, unique(d$subject)), '/', length(unique(d$subject)), '\n')
  d.sub <- d[d$subject==id, ]
  suppressMessages(suppressWarnings(
    subplot <- 
      d.sub %>% 
      group_by(size, timebin) %>% 
      summarise(pFat = mean(key_press)) %>%
      filter(timebin == 1 | timebin == 4) %>% 
      ggplot(aes(x = size, y = pFat, color = timebin)) + geom_point() + 
      geom_line(stat="smooth",method = "glm", method.args = list(
        family="binomial"), se=FALSE,size=1.8,alpha=.7) + 
      scale_colour_manual(labels=c("Initial 200 trials", "Final 200 trials"), name=NULL,values=c("#0066CC", '#990000')) +
      scale_y_continuous(labels = scales::percent) +
      scale_x_continuous(breaks = c(20, 520), 
                         labels = c('Very Thin', 'Very Overweight')) + 
      labs(y = '% Models Judged as Overweight', x='', title = id) +
      theme_bw() + 
      ylim(c(0.00, 1.00)) + 
      theme(axis.ticks.x = element_blank(), plot.title = element_text(hjust = 0.5), 
            axis.text.y = element_text(size = 10),
            axis.text.x = element_text(size = 10, colour = 'black'), 
            axis.title.y = element_text(size = 12), 
            strip.text = element_text(size = 12)) 
  ))
  
  suppressMessages(suppressWarnings(print(subplot)))
  
}
dev.off()


# Computational Models ----------------------------------------------------
modeldata <- data.frame(
  id = d$subject, 
  condition = d$condition, 
  RT = as.numeric(as.character(d$rt)), 
  response = d$key_press, 
  trialintensity = d$size
)

# * Wilson (2018) model ####
source('Models/seq/fitpicc.R')
seq.fit <- fitpicc(modeldata, stim='bodies', quickfit=T, verbose=T)

# * * Visualise parameters ####
pars = c('B0', 'Bf', 'BF', 'Bc', 'lF', 'lc')
ranges = list(c(-5, 5), c(0, 20), c(-1, 1), c(-1, 1), c(-1, 1), c(-1, 1))
plots = list()
for(p in 1:length(pars)) { 
  thisplot <- 
    seq.fit %>%
    select(id, condition, pars[p]) %>%
    melt(id.vars=c('id', 'condition')) %>%
    mutate(condition = factor(condition, levels = c('Stable', 'Increase')), 
           variable = factor(variable, 
                             levels = c('B0', 'Bf', 'BF', 'Bc', 'lF', 'lc'), 
                             ordered = T, 
                             labels = c(expression('\u03B2'[0]), 
                                        expression('\u03B2'[f]), 
                                        expression('\u03B2'[F]), 
                                        expression('\u03B2'[c]), 
                                        expression('\u03BB'[F]), 
                                        expression('\u03BB'[c])))) %>%
    ggplot(aes(x = variable, y = value, colour = condition)) +
    stat_summary(fun.y = mean, geom='point') +
    stat_summary(fun.data = mean_se, geom='errorbar', width=.2) +
    geom_hline(yintercept = 0, linetype = 'dotted', size= 1) + 
    facet_wrap(~variable, labeller = label_parsed) +
    scale_y_continuous(limits = ranges[[p]], 
                       breaks = seq(ranges[[p]][1], ranges[[p]][2], length.out = 3)) + 
    labs(x = '', y = ylab, colour = 'Condition') +
    scale_colour_manual(values=c('#4A3E3D', '#C16527')) + 
    theme_bw() +
    theme(plot.title = element_text(hjust=0.5), 
          strip.text = element_text(size=14), 
          axis.ticks.x = element_line(size = 0), 
          axis.text.x = element_blank()) 
  
  n = length(plots)+1
  plots[[n]] <- thisplot
  
}
ggarrange(plotlist = plots, common.legend = T, legend = 'bottom', nrow = 1, ncol = 6)

# * * Analyse relationship b/w params and trial0 ####
seq.fit$subject <- seq.fit$id
seq.raneff <- full_join(seq.fit, raneffs)
seq.raneff$trial0 <- as.numeric(seq.raneff$trial0)

layout(matrix(1:6, 2, 3, byrow=T))
for(p in c('B0', 'Bf', 'BF', 'Bc', 'lF', 'lc')){
  plot(x=seq.raneff$trial0, 
       y=seq.raneff[[p]], 
       xlab = 'EB', 
       ylab = p)
}

# * Drift Diffusion Model ####
library(rtdists)
source('Models/DDM/fitddm.R')
ddm.fit <- fitddm(modeldata, quickfit = T, verbose = T)

ddm.fit$subject <- ddm.fit$id
ddm.raneff <- full_join(ddm.fit, raneffs)

layout(matrix(1:10, 2, 5, byrow=T))
for(p in c('a', 't0', 'sv', 'sz', 'z', paste0('v_', 1:5))){
  plot(x=ddm.raneff$trial0, 
       y=ddm.raneff[[p]], 
       xlab = 'EB', 
       ylab = p)
}
