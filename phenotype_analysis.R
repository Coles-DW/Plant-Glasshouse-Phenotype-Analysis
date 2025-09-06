# Plant Glasshouse Phenotype Analysis
# Author: Donovin Coles
# Date: 2025
# Description: Analyze treatment and nutrient effects on disease and growth traits.

# ===============================
# Load required libraries
# ===============================
library(tidyverse)
library(ggeffects)
library(car)
library(emmeans)
library(patchwork)
library(readxl)

# ===============================
# Read data
# ===============================
dat <- readxl::read_xlsx('rawdata/phenotype_data.xlsx', na=c('', '""')) %>% 
  mutate(ph = as_factor(ph),
         nutrients = ordered(nutrients),
         trt = as_factor(trt),
         trt = relevel(trt, 'control'))  # generic reference treatment

# ===============================
# Treatment effect analysis
# ===============================

## Disease score
ggplot(dat %>% filter(nutrients == '2x'), aes(x=trt, y=`disease score`, colour=ph)) +
  geom_boxplot() +
  geom_point(position=position_dodge(width=0.75)) +
  theme_classic()

m_disease <- glm(`disease score` ~ trt * ph,
                 data=dat %>% filter(nutrients == '2x'),
                 family=poisson)

car::residualPlot(m_disease)
summary(m_disease)
car::Anova(m_disease)
ggemmeans(m_disease, 'trt') %>% plot()
contrast(emmeans(m_disease, ~ trt | ph, ci.lvl=0.9), method='dunnett', type='response') %>% 
  confint() %>% 
  as.data.frame() %>% 
  mutate(contrast = gsub(' / control', '', contrast)) %>% 
  ggplot(aes(x=contrast, y=ratio, colour=ph)) +
  geom_point(position=position_dodge(width=0.25)) +
  geom_linerange(aes(ymin=asymp.LCL, ymax=asymp.UCL),
                 position=position_dodge(width=0.25)) +
  geom_hline(yintercept=1, linetype='dashed') +
  labs(x='', y='Disease score response\n(relative to control)') +
  theme_classic()

## Root growth
ggplot(dat %>% filter(nutrients == '2x'), aes(x=trt, y=log10(`root weight`), colour=ph)) +
  geom_boxplot() +
  geom_point(position=position_dodge(width=0.75)) +
  theme_classic()

m_root <- lm(log10(`root weight`) ~ trt * ph, data=dat %>% filter(nutrients == '2x'))
car::residualPlot(m_root)
summary(m_root)
car::Anova(m_root)
ggpredict(m_root, 'trt') %>% plot()

## Shoot growth
ggplot(dat %>% filter(nutrients == '2x'), aes(x=trt, y=log10(`shoot weight`), colour=ph)) +
  geom_boxplot() +
  geom_point(position=position_dodge(width=0.75)) +
  theme_classic()

m_shoot <- lm(log10(`shoot weight`) ~ trt * ph, data=dat %>% filter(nutrients == '2x'))
car::residualPlot(m_shoot)
summary(m_shoot)
car::Anova(m_shoot)
ggpredict(m_shoot, 'trt') %>% plot()

# Combine plots if needed
p_shoot / p_root

# ===============================
# Nutrient effect analysis (control treatment only)
# ===============================
dat_control <- dat %>% filter(trt == 'control')

# Disease score
m_disease_nut <- glm(`disease score` ~ nutrients * ph,
                     data=dat_control,
                     family=poisson)
car::residualPlot(m_disease_nut)
ggpredict(m_disease_nut, c('nutrients', 'ph'), ci.lvl=0.9) %>% plot() +
  labs(x='Nutrient regime', y='Disease score')

# Root growth
m_root_nut <- lm(log10(`root weight`) ~ nutrients * ph, data=dat_control)
car::residualPlot(m_root_nut)
ggpredict(m_root_nut, c('nutrients', 'ph'), ci.lvl=0.9) %>% plot() +
  labs(x='Nutrient regime', y='Root mass (g)')

# Shoot growth
m_shoot_nut <- lm(log10(`shoot weight`) ~ nutrients * ph, data=dat_control)
car::residualPlot(m_shoot_nut)
ggpredict(m_shoot_nut, c('nutrients', 'ph'), ci.lvl=0.9) %>% plot() +
  labs(x='Nutrient regime', y='Shoot mass (g)')

# ===============================
# Save workspace
# ===============================
save.image('phenotype_analysis.RData')
