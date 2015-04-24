

setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Data/Tokens")

load("token_one.RData")
load("token_two.RData")
load("token_three.RData")

one <- as.character(token_one$Token[1:300000])
two <- as.character(token_two$Token[1:300000])
three <- as.character(token_three$Token[1:300000])

## save data to shiny 

setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Shiny")
save(one, file = "one.RData")
save(two, file = "two.RData")
save(three, file = "three.RData")

## subset data for training plot

setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Shiny")

one_training <- token_one[1:100, ]
two_training <- token_two[1:100, ]
three_training <- token_three[1:100, ]

one_training$Freq <- one_training$Freq / sum(token_one$Freq)
two_training$Freq <- two_training$Freq / sum(token_two$Freq)
three_training$Freq <- three_training$Freq / sum(token_three$Freq)

one_training$Token <- as.character(one_training$Token)
two_training$Token <- as.character(two_training$Token)
three_training$Token <- as.character(three_training$Token)

names(one_training) <- c("Token", "Probability")
names(two_training) <- c("Token", "Probability")
names(three_training) <- c("Token", "Probability")

save(one_training, file = "one_training.RData")
save(two_training, file = "two_training.RData")
save(three_training, file = "three_training.RData")

