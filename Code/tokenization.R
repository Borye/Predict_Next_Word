##---------------------------Tokenization-----------------------------------

library(RWeka)

##-----------------------------token one------------------------------------
## news

setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Data")
load("news_clean.RData")

count <- 1
count_1 <- 5000
token_one_news <- NULL
tmp <- proc.time()
for(i in 1:34){
    sample_token <- NGramTokenizer(dataframe_sample_news[count:count_1, ], Weka_control(min = 1, max = 1))
    token_one_news <- c(token_one_news, sample_token)
    count <- count + 5000
    count_1 <- count_1 + 5000
    print(i)
}
word_one_news <- data.frame(table(token_one_news))
word_one_news_order <- word_one_news[order(word_one_news$Freq, decreasing = TRUE), ]
names(word_one_news_order) <- c("Token", "Freq")
word_one_news_order$Token <- factor(word_one_news_order$Token, levels = unique(as.character(word_one_news_order$Token)))
proc.time() - tmp

setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Data/Tokens/one")
save(word_one_news_order, file = "news.RData")







## blogs
## token one

for(j in 1:14){
    tmp <- proc.time()
    setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Data/Clean")
    load(paste0("blogs_clean_", as.character(j), ".RData"))
    count <- 1
    count_1 <- 5000
    token_one <- NULL
    print(dataframe_sample[1:3, ])
    for(i in 1:34){
        sample_token <- NGramTokenizer(dataframe_sample[count:count_1, ], Weka_control(min = 1, max = 1))
        token_one <- c(token_one, sample_token)
        count <- count + 5000
        count_1 <- count_1 + 5000
        print(i)
        print(count)
        print(count_1)
    }
    word_one <- data.frame(table(token_one))
    word_one_order <- word_one[order(word_one$Freq, decreasing = TRUE), ]
    names(word_one_order) <- c("Token", "Freq")
    word_one_order$Token <- factor(word_one_order$Token, levels = unique(as.character(word_one_order$Token)))
    
    setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Data/Tokens/one")
    save(word_one_order, file = paste0("blogs_", as.character(j), ".RData"))
    rm(word_one_order)
    rm(dataframe_sample)
    
    print((proc.time() - tmp)[3]/60)
    print(paste0("finish tokenization: ", as.character(j), "/14"))
}





setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Data/Tokens/one")

#for(i in 1:14){
    #load(paste0("blogs_", as.character(i), ".RData"))
    #assign(paste0("word_one_order_blogs_", as.character(i)), word_one_order)
    #rm(word_one_order)
#}
load("blogs_1.RData")
T1 <- word_one_order
rm(word_one_order)
for(i in 2:14){
    load(paste0("blogs_", as.character(i), ".RData"))
    T2 <- word_one_order
    T1 <- merge(T1, T2, by = "Token", all = TRUE)
    T1[is.na(T1)] <- 0
    T1$SUM <- apply(T1[, c("Freq.x", "Freq.y")], 1, sum)
    T1 <- subset(T1, select = c("Token", "SUM"))
    colnames(T1) <- c("Token", "Freq")
}

word_one_blogs_order <- T1
rm(T1)
save(word_one_blogs_order, file = "blogs.RData")





## twitter

for(j in 1:28){
    tmp <- proc.time()
    setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Data/Clean")
    load(paste0("twitter_clean_", as.character(j), ".RData"))
    count <- 1
    count_1 <- 5000
    token_one <- NULL
    for(i in 1:34){
        sample_token <- NGramTokenizer(dataframe_sample[count:count_1, ], Weka_control(min = 1, max = 1))
        token_one <- c(token_one, sample_token)
        count <- count + 5000
        count_1 <- count_1 + 5000
        print(i)
        print(count)
        print(count_1)
    }
    word_one <- data.frame(table(token_one))
    word_one_order <- word_one[order(word_one$Freq, decreasing = TRUE), ]
    names(word_one_order) <- c("Token", "Freq")
    word_one_order$Token <- factor(word_one_order$Token, levels = unique(as.character(word_one_order$Token)))
    
    setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Data/Tokens/one")
    save(word_one_order, file = paste0("twitter_", as.character(j), ".RData"))
    
    print((proc.time() - tmp)[3]/60)
    print(paste0("finish tokenization: ", as.character(j), "/28"))
}


load("twitter_1.RData")
T1 <- word_one_order
rm(word_one_order)
for(i in 2:28){
    load(paste0("twitter_", as.character(i), ".RData"))
    T2 <- word_one_order
    T1 <- merge(T1, T2, by = "Token", all = TRUE)
    T1[is.na(T1)] <- 0
    T1$SUM <- apply(T1[, c("Freq.x", "Freq.y")], 1, sum)
    T1 <- subset(T1, select = c("Token", "SUM"))
    colnames(T1) <- c("Token", "Freq")
}

word_one_twitter_order <- T1
rm(T1)
save(word_one_twitter_order, file = "twitter.RData")


load("news.RData")
load("blogs.RData")
load("twitter.RData")

T1 <- word_one_blogs_order
T2 <- word_one_news_order
T3 <- word_one_twitter_order

Ta <- merge(T1, T2, by = "Token", all = TRUE)
Ta[is.na(Ta)] <- 0
Ta$SUM <- apply(Ta[, c("Freq.x", "Freq.y")], 1, sum)
Ta <- subset(Ta, select = c("Token", "SUM"))
colnames(Ta) <- c("Token", "Freq")

Ta <- merge(Ta, T3, by = "Token", all = TRUE)
Ta[is.na(Ta)] <- 0
Ta$SUM <- apply(Ta[, c("Freq.x", "Freq.y")], 1, sum)
Ta <- subset(Ta, select = c("Token", "SUM"))
colnames(Ta) <- c("Token", "Freq")

Ta <- Ta[-grep("^NA$", Ta$Token, perl = TRUE, value = FALSE), ]
Ta <- Ta[-grep("^na$", Ta$Token, perl = TRUE, value = FALSE), ]

one <- Ta
setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Data/Tokens")
save(one, file = "token_one.RData")




##---------------------------token two---------------------------------

setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Data")
load("news_clean.RData")

count <- 1
count_1 <- 5000
token_two_news <- NULL
tmp <- proc.time()
for(i in 1:34){
    sample_token <- NGramTokenizer(dataframe_sample_news[count:count_1, ], Weka_control(min = 2, max = 2))
    token_two_news <- c(token_two_news, sample_token)
    count <- count + 5000
    count_1 <- count_1 + 5000
    print(i)
}
word_two_news <- data.frame(table(token_two_news))
word_two_news_order <- word_two_news[order(word_two_news$Freq, decreasing = TRUE), ]
names(word_two_news_order) <- c("Token", "Freq")
word_two_news_order$Token <- factor(word_two_news_order$Token, levels = unique(as.character(word_two_news_order$Token)))
proc.time() - tmp

setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Data/Tokens/two")
save(word_two_news_order, file = "news.RData")





## blogs
## token two

for(j in 1:14){
    tmp <- proc.time()
    setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Data/Clean")
    load(paste0("blogs_clean_", as.character(j), ".RData"))
    count <- 1
    count_1 <- 5000
    token_two <- NULL
    for(i in 1:34){
        sample_token <- NGramTokenizer(dataframe_sample[count:count_1, ], Weka_control(min = 2, max = 2))
        token_two <- c(token_two, sample_token)
        count <- count + 5000
        count_1 <- count_1 + 5000
        print(i)
    }
    word_two <- data.frame(table(token_two))
    word_two_order <- word_two[order(word_two$Freq, decreasing = TRUE), ]
    names(word_two_order) <- c("Token", "Freq")
    word_two_order$Token <- factor(word_two_order$Token, levels = unique(as.character(word_two_order$Token)))
    
    setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Data/Tokens/two")
    save(word_two_order, file = paste0("blogs_", as.character(j), ".RData"))
    rm(word_two_order)
    rm(dataframe_sample)
    
    print((proc.time() - tmp)[3]/60)
    print(paste0("finish tokenization: ", as.character(j), "/14"))
}





setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Data/Tokens/two")

#for(i in 1:14){
#load(paste0("blogs_", as.character(i), ".RData"))
#assign(paste0("word_two_order_blogs_", as.character(i)), word_two_order)
#rm(word_two_order)
#}
load("blogs_1.RData")
T1 <- word_two_order
rm(word_two_order)
for(i in 2:14){
    load(paste0("blogs_", as.character(i), ".RData"))
    T2 <- word_two_order
    T1 <- merge(T1, T2, by = "Token", all = TRUE)
    T1[is.na(T1)] <- 0
    T1$SUM <- apply(T1[, c("Freq.x", "Freq.y")], 1, sum)
    T1 <- subset(T1, select = c("Token", "SUM"))
    colnames(T1) <- c("Token", "Freq")
    print(i)
}

word_two_blogs_order <- T1
rm(T1)
save(word_two_blogs_order, file = "blogs.RData")



## twitter
for(j in 1:28){
    tmp <- proc.time()
    setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Data/Clean")
    load(paste0("twitter_clean_", as.character(j), ".RData"))
    count <- 1
    count_1 <- 5000
    token_two <- NULL
    for(i in 1:34){
        sample_token <- NGramTokenizer(dataframe_sample[count:count_1, ], Weka_control(min = 2, max = 2))
        token_two <- c(token_two, sample_token)
        count <- count + 5000
        count_1 <- count_1 + 5000
        print(i)
    }
    word_two <- data.frame(table(token_two))
    word_two_order <- word_two[order(word_two$Freq, decreasing = TRUE), ]
    names(word_two_order) <- c("Token", "Freq")
    word_two_order$Token <- factor(word_two_order$Token, levels = unique(as.character(word_two_order$Token)))
    
    setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Data/Tokens/two")
    save(word_two_order, file = paste0("twitter_", as.character(j), ".RData"))
    
    print((proc.time() - tmp)[3]/60)
    print(paste0("finish tokenization: ", as.character(j), "/28"))
}


load("twitter_1.RData")
T1 <- word_two_order
rm(word_two_order)
for(i in 2:28){
    load(paste0("twitter_", as.character(i), ".RData"))
    T2 <- word_two_order
    T1 <- merge(T1, T2, by = "Token", all = TRUE)
    T1[is.na(T1)] <- 0
    T1$SUM <- apply(T1[, c("Freq.x", "Freq.y")], 1, sum)
    T1 <- subset(T1, select = c("Token", "SUM"))
    colnames(T1) <- c("Token", "Freq")
    print(i)
}

word_two_twitter_order <- T1
rm(T1)
save(word_two_twitter_order, file = "twitter.RData")


load("news.RData")
load("blogs.RData")
load("twitter.RData")

T1 <- word_two_blogs_order
T2 <- word_two_news_order
T3 <- word_two_twitter_order

Ta <- merge(T1, T2, by = "Token", all = TRUE)
Ta[is.na(Ta)] <- 0
Ta$SUM <- apply(Ta[, c("Freq.x", "Freq.y")], 1, sum)
Ta <- subset(Ta, select = c("Token", "SUM"))
colnames(Ta) <- c("Token", "Freq")

Ta <- merge(Ta, T3, by = "Token", all = TRUE)
Ta[is.na(Ta)] <- 0
Ta$SUM <- apply(Ta[, c("Freq.x", "Freq.y")], 1, sum)
Ta <- subset(Ta, select = c("Token", "SUM"))
colnames(Ta) <- c("Token", "Freq")

two <- Ta
setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Data/Tokens")
save(two, file = "token_two.RData")


##---------------------------------token three---------------------------------


setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Data")
load("news_clean.RData")

count <- 1
count_1 <- 5000
token_three_news <- NULL
tmp <- proc.time()
for(i in 1:34){
    sample_token <- NGramTokenizer(dataframe_sample_news[count:count_1, ], Weka_control(min = 3, max = 3))
    token_three_news <- c(token_three_news, sample_token)
    count <- count + 5000
    count_1 <- count_1 + 5000
    print(i)
}
word_three_news <- data.frame(table(token_three_news))
word_three_news_order <- word_three_news[order(word_three_news$Freq, decreasing = TRUE), ]
names(word_three_news_order) <- c("Token", "Freq")
word_three_news_order$Token <- factor(word_three_news_order$Token, levels = unique(as.character(word_three_news_order$Token)))
proc.time() - tmp

setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Data/Tokens/three")
save(word_three_news_order, file = "news.RData")





## blogs
for(j in 1:14){
    tmp <- proc.time()
    setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Data/Clean")
    load(paste0("blogs_clean_", as.character(j), ".RData"))
    count <- 1
    count_1 <- 5000
    token_three <- NULL
    for(i in 1:34){
        sample_token <- NGramTokenizer(dataframe_sample[count:count_1, ], Weka_control(min = 3, max = 3))
        token_three <- c(token_three, sample_token)
        count <- count + 5000
        count_1 <- count_1 + 5000
        print(i)
    }
    word_three <- data.frame(table(token_three))
    word_three_order <- word_three[order(word_three$Freq, decreasing = TRUE), ]
    names(word_three_order) <- c("Token", "Freq")
    word_three_order$Token <- factor(word_three_order$Token, levels = unique(as.character(word_three_order$Token)))
    
    setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Data/Tokens/three")
    save(word_three_order, file = paste0("blogs_", as.character(j), ".RData"))
    rm(word_three_order)
    rm(dataframe_sample)
    
    print((proc.time() - tmp)[3]/60)
    print(paste0("finish tokenization: ", as.character(j), "/14"))
}





setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Data/Tokens/three")

#for(i in 1:14){
#load(paste0("blogs_", as.character(i), ".RData"))
#assign(paste0("word_three_order_blogs_", as.character(i)), word_three_order)
#rm(word_three_order)
#}
load("blogs_1.RData")
T1 <- word_three_order
rm(word_three_order)
for(i in 2:14){
    tmp <- proc.time()
    load(paste0("blogs_", as.character(i), ".RData"))
    T2 <- word_three_order
    T1 <- merge(T1, T2, by = "Token", all = TRUE)
    T1[is.na(T1)] <- 0
    T1$SUM <- apply(T1[, c("Freq.x", "Freq.y")], 1, sum)
    T1 <- subset(T1, select = c("Token", "SUM"))
    colnames(T1) <- c("Token", "Freq")
    print(i)
    print((proc.time() - tmp)[3] / 60)
}

word_three_blogs_order <- T1
rm(T1)
save(word_three_blogs_order, file = "blogs.RData")




## twitter
for(j in 1:28){
    tmp <- proc.time()
    setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Data/Clean")
    load(paste0("twitter_clean_", as.character(j), ".RData"))
    count <- 1
    count_1 <- 5000
    token_three <- NULL
    for(i in 1:34){
        sample_token <- NGramTokenizer(dataframe_sample[count:count_1, ], Weka_control(min = 3, max = 3))
        token_three <- c(token_three, sample_token)
        count <- count + 5000
        count_1 <- count_1 + 5000
        print(i)
    }
    word_three <- data.frame(table(token_three))
    word_three_order <- word_three[order(word_three$Freq, decreasing = TRUE), ]
    names(word_three_order) <- c("Token", "Freq")
    word_three_order$Token <- factor(word_three_order$Token, levels = unique(as.character(word_three_order$Token)))
    
    setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Data/Tokens/three")
    save(word_three_order, file = paste0("twitter_", as.character(j), ".RData"))
    
    print((proc.time() - tmp)[3]/60)
    print(paste0("finish tokenization: ", as.character(j), "/28"))
}


load("twitter_1.RData")
T1 <- word_three_order
rm(word_three_order)
for(i in 2:28){
    load(paste0("twitter_", as.character(i), ".RData"))
    T2 <- word_three_order
    T1 <- merge(T1, T2, by = "Token", all = TRUE)
    T1[is.na(T1)] <- 0
    T1$SUM <- apply(T1[, c("Freq.x", "Freq.y")], 1, sum)
    T1 <- subset(T1, select = c("Token", "SUM"))
    colnames(T1) <- c("Token", "Freq")
    print(i)
}

word_three_twitter_order <- T1
rm(T1)
save(word_three_twitter_order, file = "twitter.RData")


load("news.RData")
load("blogs.RData")
load("twitter.RData")

T1 <- word_three_blogs_order
T2 <- word_three_news_order
T3 <- word_three_twitter_order

Ta <- merge(T1, T2, by = "Token", all = TRUE)
Ta[is.na(Ta)] <- 0
Ta$SUM <- apply(Ta[, c("Freq.x", "Freq.y")], 1, sum)
Ta <- subset(Ta, select = c("Token", "SUM"))
colnames(Ta) <- c("Token", "Freq")

Ta <- merge(Ta, T3, by = "Token", all = TRUE)
Ta[is.na(Ta)] <- 0
Ta$SUM <- apply(Ta[, c("Freq.x", "Freq.y")], 1, sum)
Ta <- subset(Ta, select = c("Token", "SUM"))
colnames(Ta) <- c("Token", "Freq")

three <- Ta
setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Data/Tokens")
save(three, file = "token_three.RData")


load("token_one.RData")
load("token_two.RData")
load("token_three.RData")


one_order <- one[order(one$Freq, decreasing = TRUE), ]
one_order$Token <- factor(one_order$Token, levels = unique(as.character(one_order$Token)))

two_order <- two[order(two$Freq, decreasing = TRUE), ]
two_order$Token <- factor(two_order$Token, levels = unique(as.character(two_order$Token)))

three_order <- three[order(three$Freq, decreasing = TRUE), ]
three_order$Token <- factor(three_order$Token, levels = unique(as.character(three_order$Token)))


save(token_one, file = "token_one.RData")
save(token_two, file = "token_two.RData")
save(token_three, file = "token_three.RData")