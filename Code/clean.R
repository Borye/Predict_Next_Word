library(tm)
library(SnowballC)

setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Data")

## news

load("news_sentdetect.RData")

##-------------------------remove non-ASCII characters---------------------------------


for(i in 1:length(data_sample_news)){
    row <- data_sample_news[i]
    row_1 <- iconv(row, "latin1", "ASCII", sub = "")
    data_sample_news[i] <- row_1
}

##-------------------------create corpus-------------------------------------------

library(tm)
library(SnowballC)

corpus_sample <- VCorpus(VectorSource(data_sample_news))
corpus_sample <- tm_map(corpus_sample, content_transformer(tolower))       ## conversion by lower case
# corpus_sample <- tm_map(corpus_sample, stemDocument)         ## stemming, need package "SnowballC"
corpus_sample <- tm_map(corpus_sample, stripWhitespace)        ## eliminate extra white space
corpus_sample <- tm_map(corpus_sample, removePunctuation)   ## remove punctuation characters like period
# corpus_sample <- tm_map(corpus_sample, removeWords, stopwords("english"))  ## remove stop words 

# inspect(corpus_sample) see the corpus_sample

##-----------------------------profanity filtering--------------------------------

con_profanity <- file("C:/Users/Borye/Documents/R/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words-master/en", "r")
profanity <- readLines(con_profanity)
close(con_profanity)
corpus_sample <- tm_map(corpus_sample, removeWords, profanity)

##----------------------------convert corpus to data frame---------------------------

dataframe_sample_news <- data.frame(text = unlist(sapply(corpus_sample, '[', 'content')), stringsAsFactors = F)

setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Data")
save(dataframe_sample_news, file = "news_clean.RData")







## blogs

load("blogs_sentdetect.RData")

count <- 1
count_1 <- 155000
dataframe_sample_blogs <- data.frame(text = 0)
tmp <- proc.time()
for(j in 1:14){
    data_sample <- data_sample_blogs[count:count_1]
    for(i in 1:length(data_sample)){
        row <- data_sample[i]
        row_1 <- iconv(row, "latin1", "ASCII", sub = "")
        data_sample[i] <- row_1
    }
    
    ##-------------------------create corpus-------------------------------------------
    

    
    corpus_sample <- VCorpus(VectorSource(data_sample))
    corpus_sample <- tm_map(corpus_sample, content_transformer(tolower))       ## conversion by lower case
    # corpus_sample <- tm_map(corpus_sample, stemDocument)         ## stemming, need package "SnowballC"
    corpus_sample <- tm_map(corpus_sample, stripWhitespace)        ## eliminate extra white space
    corpus_sample <- tm_map(corpus_sample, removePunctuation)   ## remove punctuation characters like period
    # corpus_sample <- tm_map(corpus_sample, removeWords, stopwords("english"))  ## remove stop words 
    
    # inspect(corpus_sample) see the corpus_sample
    
    ##-----------------------------profanity filtering--------------------------------
    
    con_profanity <- file("C:/Users/Borye/Documents/R/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words-master/en", "r")
    profanity <- readLines(con_profanity)
    close(con_profanity)
    corpus_sample <- tm_map(corpus_sample, removeWords, profanity)
    
    ##----------------------------convert corpus to data frame---------------------------
    
    dataframe_sample <- data.frame(text = unlist(sapply(corpus_sample, '[', 'content')), stringsAsFactors = F)
    setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Data/Clean")
    save(dataframe_sample, file = paste0("blogs_clean_", as.character(j), ".RData"))
    rm(dataframe_sample)
    count <- count + 155000
    count_1 <- count_1 + 155000
    print(j)
}
proc.time() - tmp



## twitter

load("twitter_sentdetect.RData")

count <- 1
count_1 <- 155000
dataframe_sample_twitter <- data.frame(text = 0)
for(j in 1:28){
    tmp <- proc.time()
    data_sample <- data_sample_twitter[count:count_1]
    for(i in 1:length(data_sample)){
        row <- data_sample[i]
        row_1 <- iconv(row, "latin1", "ASCII", sub = "")
        data_sample[i] <- row_1
    }
    
    ##-------------------------create corpus-------------------------------------------
    
    
    
    corpus_sample <- VCorpus(VectorSource(data_sample))
    corpus_sample <- tm_map(corpus_sample, content_transformer(tolower))       ## conversion by lower case
    # corpus_sample <- tm_map(corpus_sample, stemDocument)         ## stemming, need package "SnowballC"
    corpus_sample <- tm_map(corpus_sample, stripWhitespace)        ## eliminate extra white space
    corpus_sample <- tm_map(corpus_sample, removePunctuation)   ## remove punctuation characters like period
    # corpus_sample <- tm_map(corpus_sample, removeWords, stopwords("english"))  ## remove stop words 
    
    # inspect(corpus_sample) see the corpus_sample
    
    ##-----------------------------profanity filtering--------------------------------
    
    con_profanity <- file("C:/Users/Borye/Documents/R/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words-master/en", "r")
    profanity <- readLines(con_profanity)
    close(con_profanity)
    corpus_sample <- tm_map(corpus_sample, removeWords, profanity)
    
    ##----------------------------convert corpus to data frame---------------------------
    
    dataframe_sample <- data.frame(text = unlist(sapply(corpus_sample, '[', 'content')), stringsAsFactors = F)
    setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Data/Clean")
    save(dataframe_sample, file = paste0("twitter_clean_", as.character(j), ".RData"))
    rm(dataframe_sample)
    count <- count + 155000
    count_1 <- count_1 + 155000
    print(j)
    print(count)
    print((proc.time() - tmp)[3]/60)
}

