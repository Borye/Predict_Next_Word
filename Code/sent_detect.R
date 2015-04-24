## load data
setwd("C:/Users/Borye/Documents/")

con_blogs <- file("./R/Coursera-SwiftKey/final/en_US/en_US.blogs.txt", "r")
data_blogs <- readLines(con_blogs)
length(data_blogs)                    ## length of blogs data
close(con_blogs)

con_news <- file("./R/Coursera-SwiftKey/final/en_US/en_US.news.txt", "r")
data_news <- readLines(con_news)
length(data_news)                     ## length of news data
close(con_news)

con_twitter <- file("./R/Coursera-SwiftKey/final/en_US/en_US.twitter.txt", "r")
data_twitter <- readLines(con_twitter)
length(data_twitter)                    ## length of twitter data
close(con_twitter)


## sent_detect
## blogs

count <- 1
count_1 <- 10000
data_sample <- NULL
tmp <- proc.time()
for(i in 1:89){
    sample <- sent_detect(data_blogs[count:count_1])
    data_sample <- c(data_sample, sample)
    count <- count + 10000
    count_1 <- count + 10000
    print(i)
}
proc.time() - tmp

data_sample_blogs <- data_sample

setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Data")
save(data_sample_blogs, file = "blogs_sentdetect.RData")

## twitter

count <- 1
count_1 <- 10000
data_sample_twitter <- NULL
tmp <- proc.time()
for(i in 1:230){
    data_twitter_sample <- data_twitter[count:count_1]
    tw <- c(NULL)
    for(j in 1:length(data_twitter_sample)){
        tw_eve <- sent_detect(data_twitter_sample[j])
        tw <- c(tw, tw_eve)
    }
    data_sample_twitter <- c(data_sample_twitter, tw)
    count <- count + 10000
    count_1 <- count + 10000
    print(i)
}
proc.time() - tmp

setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Data")
save(data_sample_twitter, file = "twitter_sentdetect.RData")

## news

count <- 1
count_1 <- 10000
data_sample <- NULL
tmp <- proc.time()
for(i in 1:15){
    sample <- sent_detect(data_news[count:count_1])
    data_sample <- c(data_sample, sample)
    count <- count + 5000
    count_1 <- count + 5000
    print(i)
}
proc.time() - tmp

data_sample_news <- data_sample

setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Data")
save(data_sample_news, file = "news_sentdetect.RData")
