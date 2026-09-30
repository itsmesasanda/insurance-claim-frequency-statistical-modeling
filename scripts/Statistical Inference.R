library(dplyr)

df <- read.csv("/Users/sasanda/Documents/insuarance claim prediction/data/freMTPL2freq.csv")

# create claim / no-claim variable
df <- df %>%
  mutate(ClaimOccurred = ClaimNb > 0)

# claim occurrence by fuel type
fuel_claim <- df %>%
  group_by(VehGas) %>%
  summarise(
    Policies = n(),
    Claim_Policies = sum(ClaimOccurred),
    Claim_Proportion = mean(ClaimOccurred),
    .groups = "drop"
  )

fuel_claim

# two-proportion test
fuel_test <- prop.test(
  x = fuel_claim$Claim_Policies,
  n = fuel_claim$Policies
)

fuel_test

# Analysis 2 - Claim occurrence and Area

area_table <- table(
  df$Area,
  df$ClaimOccurred
)

area_table

area_test <- chisq.test(area_table)

area_test

# claim proportion by Area
area_claim <- df %>%
  group_by(Area) %>%
  summarise(
    Policies = n(),
    Claim_Policies = sum(ClaimOccurred),
    Claim_Proportion = mean(ClaimOccurred),
    .groups = "drop"
  )

area_claim

# Analysis 3 - BonusMalus: claim vs no claim

bonus_claim <- df %>%
  group_by(ClaimOccurred) %>%
  summarise(
    Policies = n(),
    Mean_BonusMalus = mean(BonusMalus),
    SD_BonusMalus = sd(BonusMalus),
    .groups = "drop"
  )

bonus_claim

bonus_test <- t.test(
  BonusMalus ~ ClaimOccurred,
  data = df
)

bonus_test

# Analysis 4 - Driver age and claim rate

driver_data <- df %>%
  mutate(
    Driver_Age_Group = cut(
      DrivAge,
      breaks = c(18, 25, 35, 45, 55, 65, 75, 101),
      labels = c("18-24", "25-34", "35-44", "45-54",
                 "55-64", "65-74", "75+"),
      right = FALSE
    )
  )

# observed claim frequency by age group
driver_claim <- driver_data %>%
  group_by(Driver_Age_Group) %>%
  summarise(
    Policies = n(),
    Claims = sum(ClaimNb),
    Exposure = sum(Exposure),
    Claim_Frequency = Claims / Exposure,
    .groups = "drop"
  )

driver_claim

# Poisson model including exposure
driver_model <- glm(
  ClaimNb ~ Driver_Age_Group + offset(log(Exposure)),
  family = poisson,
  data = driver_data
)

summary(driver_model)

# overall test for driver age
driver_null <- glm(
  ClaimNb ~ offset(log(Exposure)),
  family = poisson,
  data = driver_data
)

anova(
  driver_null,
  driver_model,
  test = "Chisq"
)

# rate ratios compared with the 18-24 group
exp(coef(driver_model))

# Analysis 5 - Vehicle age and claim rate

vehicle_data <- df %>%
  mutate(
    Vehicle_Age_Group = cut(
      VehAge,
      breaks = c(0, 3, 6, 11, 16, 21, 31, 101),
      labels = c("0-2", "3-5", "6-10", "11-15",
                 "16-20", "21-30", "31+"),
      right = FALSE
    )
  )

# observed claim frequency by vehicle age group
vehicle_claim <- vehicle_data %>%
  group_by(Vehicle_Age_Group) %>%
  summarise(
    Policies = n(),
    Claims = sum(ClaimNb),
    Exposure = sum(Exposure),
    Claim_Frequency = Claims / Exposure,
    .groups = "drop"
  )

vehicle_claim

# Poisson model including exposure
vehicle_model <- glm(
  ClaimNb ~ Vehicle_Age_Group + offset(log(Exposure)),
  family = poisson,
  data = vehicle_data
)

summary(vehicle_model)

# overall test for vehicle age
vehicle_null <- glm(
  ClaimNb ~ offset(log(Exposure)),
  family = poisson,
  data = vehicle_data
)

anova(
  vehicle_null,
  vehicle_model,
  test = "Chisq"
)

# rate ratios compared with the 0-2 group
exp(coef(vehicle_model))

# Analysis 6 - Area, BonusMalus and Density claim rates


# 6.1 Area

area_rate_model <- glm(
  ClaimNb ~ Area + offset(log(Exposure)),
  family = poisson,
  data = df
)

area_rate_null <- glm(
  ClaimNb ~ offset(log(Exposure)),
  family = poisson,
  data = df
)

anova(
  area_rate_null,
  area_rate_model,
  test = "Chisq"
)

exp(coef(area_rate_model))


# 6.2 BonusMalus groups

bonus_rate_data <- df %>%
  mutate(
    Bonus_Group = cut(
      BonusMalus,
      breaks = c(50, 60, 70, 80, 100, 150, 201, 231),
      labels = c("50-59", "60-69", "70-79", "80-99",
                 "100-149", "150-200", "201+"),
      right = FALSE
    )
  )

bonus_rate_model <- glm(
  ClaimNb ~ Bonus_Group + offset(log(Exposure)),
  family = poisson,
  data = bonus_rate_data
)

bonus_rate_null <- glm(
  ClaimNb ~ offset(log(Exposure)),
  family = poisson,
  data = bonus_rate_data
)

anova(
  bonus_rate_null,
  bonus_rate_model,
  test = "Chisq"
)

exp(coef(bonus_rate_model))


# 6.3 Density groups

density_breaks <- quantile(
  df$Density,
  c(0, 0.25, 0.50, 0.75, 1)
)

density_rate_data <- df %>%
  mutate(
    Density_Group = cut(
      Density,
      breaks = density_breaks,
      labels = c(
        "Low",
        "Medium-Low",
        "Medium-High",
        "High"
      ),
      include.lowest = TRUE
    )
  )

density_rate_model <- glm(
  ClaimNb ~ Density_Group + offset(log(Exposure)),
  family = poisson,
  data = density_rate_data
)

density_rate_null <- glm(
  ClaimNb ~ offset(log(Exposure)),
  family = poisson,
  data = density_rate_data
)

anova(
  density_rate_null,
  density_rate_model,
  test = "Chisq"
)

exp(coef(density_rate_model))

