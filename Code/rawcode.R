##--------------------------------Load file---------------------------------------
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


##--------------------------------Take sampling----------------------------------
## Here we use 1000 samples to represent the whole dataset

sample_blogs <- sample(1:length(data_blogs), 5000, replace = FALSE)
data_blogs_sample <- data_blogs[sample_blogs]

sample_news <- sample(1:length(data_news), 5000, replace = FALSE)
data_news_sample <- data_news[sample_news]

sample_twitter <- sample(1:length(data_twitter), 5000, replace = FALSE)
data_twitter_sample <- data_twitter[sample_twitter]

##-------------------------------Data preprocessing-------------------------------
## create corpus

library(qdap)

data_sample <- c(data_blogs_sample, data_news_sample)           #!!!!!!!!!!!!!!, data_twitter_sample)
data_sample <- sent_detect(data_sample)

## deal with twitter

tw <- c(NULL)
for(i in 1:length(data_twitter_sample)){
    tw_eve <- sent_detect(data_twitter_sample[i])
    tw <- c(tw, tw_eve)
}

data_sample <- c(data_sample, tw)

## remove non-ASCII characters

for(i in 1:length(data_sample)){
    row <- data_sample[i]
    row_1 <- iconv(row, "latin1", "ASCII", sub = "")
    data_sample[i] <- row_1
}

library(tm)
library(SnowballC)

corpus_sample <- VCorpus(VectorSource(data_sample))
corpus_sample <- tm_map(corpus_sample, content_transformer(tolower))       ## conversion by lower case
# corpus_sample <- tm_map(corpus_sample, stemDocument)         ## stemming, need package "SnowballC"
corpus_sample <- tm_map(corpus_sample, stripWhitespace)        ## eliminate extra white space
corpus_sample <- tm_map(corpus_sample, removePunctuation)   ## remove punctuation characters like period
# corpus_sample <- tm_map(corpus_sample, removeWords, stopwords("english"))  ## remove stop words 

# inspect(corpus_sample) see the corpus_sample

## profanity filtering

con_profanity <- file("./R/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words-master/en", "r")
profanity <- readLines(con_profanity)
close(con_profanity)
corpus_sample <- tm_map(corpus_sample, removeWords, profanity)

## convert corpus to data frame

dataframe_sample <- data.frame(text = unlist(sapply(corpus_sample, '[', 'content')), stringsAsFactors = F)

## tokenization

library(RWeka)

# WOW(NGramTokenizer)   see what can be done using NGramTokenizer by Weka_control

token_one <- NGramTokenizer(dataframe_sample, Weka_control(min = 1, max = 1))
token_two <- NGramTokenizer(dataframe_sample, Weka_control(min = 2, max = 2))
token_three <- NGramTokenizer(dataframe_sample, Weka_control(min = 3, max = 3))
token_four <- NGramTokenizer(dataframe_sample, Weka_control(min = 4, max = 4))

word_one <- data.frame(table(token_one))
word_two <- data.frame(table(token_two))
word_three <- data.frame(table(token_three))
word_four <- data.frame(table(token_four))

word_one_order <- word_one[order(word_one$Freq, decreasing = TRUE), ]
word_two_order <- word_two[order(word_two$Freq, decreasing = TRUE), ]
word_three_order <- word_three[order(word_three$Freq, decreasing = TRUE), ]
word_four_order <- word_four[order(word_four$Freq, decreasing = TRUE), ]

names(word_one_order) <- c("Token", "Freq")
names(word_two_order) <- c("Token", "Freq")
names(word_three_order) <- c("Token", "Freq")
names(word_four_order) <- c("Token", "Freq")

##-----------------------------Exploratory Analysis-------------------------

library(ggplot2)
library(RColorBrewer) 

# display.brewer.all(11)    # display all brewer colors

## remove the order of "token" in every word, to let it order by Freq in the ggplot

word_one_order$Token <- factor(word_one_order$Token, levels = unique(as.character(word_one_order$Token)))
word_two_order$Token <- factor(word_two_order$Token, levels = unique(as.character(word_two_order$Token)))
word_three_order$Token <- factor(word_three_order$Token, levels = unique(as.character(word_three_order$Token)))
word_four_order$Token <- factor(word_four_order$Token, levels = unique(as.character(word_four_order$Token)))

## plot

ggplot(word_one_order[1:11, ], aes(Token, Freq, fill = Token)) + geom_bar(stat="Identity", width = .8) +
    geom_text(aes(label = word_one_order[1:11, ]$Freq), vjust = -0.2) + scale_fill_manual(values = brewer.pal(11, "BrBG")) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 15))

ggplot(word_two_order[1:11, ], aes(Token, Freq, fill = Token)) + geom_bar(stat="Identity", width = .8) +
    geom_text(aes(label = word_two_order[1:11, ]$Freq), vjust = -0.2) + scale_fill_manual(values = brewer.pal(11, "PiYG")) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 15))

ggplot(word_three_order[1:11, ], aes(Token, Freq, fill = Token)) + geom_bar(stat="Identity", width = .8) +
    geom_text(aes(label = word_three_order[1:11, ]$Freq), vjust = -0.2) + scale_fill_manual(values = brewer.pal(11, "RdYlGn")) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 15))
    
## wordcloud

library(wordcloud)

wordcloud(word_one_order[1:11, ]$Token, word_one_order[1:11, ]$Freq, scale = c(4,1), rot.per = .3, colors = brewer.pal(11, "BrBG"), ordered.colors = TRUE, random.order = TRUE)

wordcloud(word_two_order[1:11, ]$Token, word_two_order[1:11, ]$Freq, scale = c(4,1), rot.per = .3, colors = brewer.pal(11, "PiYG"), ordered.colors = TRUE, random.order = TRUE)

wordcloud(word_three_order[1:11, ]$Token, word_three_order[1:11, ]$Freq, scale = c(4,1), rot.per = .3, colors = brewer.pal(11, "RdYlGn"), ordered.colors = TRUE, random.order = TRUE)

## How many unique words do you need in a frequency sorted dictionary to cover 50% of all word instances in the language?

num_count <- 0
count <- 0
s <- sum(word_one_order$Freq)
for(i in 1:dim(word_one_order)[1]){
    num_count = num_count + word_one_order$Freq[i]
    count = count + 1
    if(num_count >= s/2){
        break
    }
}
count

## What if 90%

num_count <- 0
count <- 0
s <- sum(word_one_order$Freq)
for(i in 1:dim(word_one_order)[1]){
    num_count = num_count + word_one_order$Freq[i]
    count = count + 1
    if(num_count >= s * 0.9){
        break
    }
}
count




