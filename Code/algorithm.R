##-------------------------Prepared data-------------------------------------

one <- word_one_order$Token
two <- word_two_order$Token
three <- word_three_order$Token

##------------------------oneword_predict----------------------------------------
## This prediction based on one word given, and output is three most frequent words

x <- "the"

oneword_predict <- function(x, two, one){
    se <- grep(paste0("^", x, "\\s"), two, perl = TRUE, value = FALSE)
    if(length(se) == 0){
        print(c(as.character(one[1]), as.character(one[2]), as.character(one[3])))
    }else{
        num <- length(se)
        word <- NULL
        i <- 1
        while(i <= 3 && i <= num){
            word[i] <- unlist(strsplit(as.character(two[se][i]), "\\s"))[2]
            i = i + 1
        }
        print(word)
    }
}

oneword_predict(x, two, one)

##------------------------twoword_predict---------------------------

twoword_predict <- function(x, one, two, three){
    se <- grep(paste0("^", x, "\\s"), three, perl = TRUE, value = FALSE)
    num <- length(se)
    word <- NULL
    i <- 1
    while(i <= 3 && i <= num){
        word[i] <- unlist(strsplit(as.character(three[se][i]), "\\s"))[3]
        i = i + 1
    }
    if(length(word) != 3){
        second <- strsplit(x, "\\s")[[1]][2]
        se <- grep(paste0("^", second, "\\s"), two, perl = TRUE, value = FALSE)
        num <- length(se)
        len <- length(word)
        while(i <= 3 && i <= num + len){
            word[i] <- unlist(strsplit(as.character(two[se][i - len]), "\\s"))[2]
            i = i + 1
        }
        if(length(word) != 3){
            j <- 0
            len <- length(word)
            while(i <= 3){
                word[i] <- as.character(one[1 + j])
                i <- i + 1
                j <- j + 1
            }
        }
    }
    print(word)

}

x <- "i need"

one <- word_one_order$Token
two <- word_two_order$Token
three <- word_three_order$Token

twoword_predict(x, one, two, three)

##------------------------threeword_predict---------------------

threeword_predict <- function(x, one, two, three, four){
    se <- grep(paste0("^", x, "\\s"), four, perl = TRUE, value = FALSE)
    num <- length(se)
    word <- NULL
    i <- 1
    while(i <= 3 && i <= num){
        word[i] <- unlist(strsplit(as.character(four[se][i]), "\\s"))[4]
        i = i + 1
    }
    if(length(word) != 3){
        second <- paste(strsplit(x, "\\s")[[1]][2], strsplit(x, "\\s")[[1]][3])
        se <- grep(paste0("^", second, "\\s"), three, perl = TRUE, value = FALSE)
        num <- length(se)
        len <- length(word)
        while(i <= 3 && i <= num + len){
            temp <- unlist(strsplit(as.character(three[se][i - len]), "\\s"))[3]
            k <- 1
            while(length(grep(temp, word, perl = TRUE, value = FALSE)) != 0){
                temp <- unlist(strsplit(as.character(three[se][i - len + k]), "\\s"))[3]
                k = k + 1
            }
            word[i] <- temp
            i = i + 1
        }
        if(length(word) != 3){
            third <- paste(strsplit(x, "\\s")[[1]][3])
            se <- grep(paste0("^", third, "\\s"), two, perl = TRUE, value = FALSE)
            num <- length(se)
            len <- length(word)
            while(i <= 3 && i <= num + len){
                temp <- unlist(strsplit(as.character(two[se][i - len]), "\\s"))[2]
                k <- 1
                while(length(grep(temp, word, perl = TRUE, value = FALSE)) != 0){
                    temp <- unlist(strsplit(as.character(three[se][i - len + k]), "\\s"))[2]
                    k = k + 1
                }
                word[i] <- temp
                i = i + 1
            }
            if(length(word) != 3){
                j <- 0
                len <- length(word)
                while(i <= 3){
                    word[i] <- as.character(one[1 + j])
                    i <- i + 1
                    j <- j + 1
                }
            }
        }
    }
    print(word)
}


x <- "Buffy the Vampire"

one <- word_one_order$Token
two <- word_two_order$Token
three <- word_three_order$Token
four <- word_four_order$Token

threeword_predict(x, one, two, three, four)


##------------------------stupid backoff----------------------------

sb_predict <- function(x, one, two, three){
    sb3 <- grep(paste0("^", x, "\\s"), three$Token, perl = TRUE, value = FALSE)
    sb32 <- grep(paste0("^", x, "$"), two$Token, perl = TRUE, value = FALSE)
    x2 <- strsplit(x, "\\s")[[1]][2]
    sb2 <- grep(paste0("^", x2, "\\s"), two$Token, perl = TRUE, value = FALSE)
    sb21 <- grep(paste0("^", x2, "$"), one$Token, perl = TRUE, value = FALSE)
    
    df3 <- three[sb3, ]
    df3$Prob <- df3$Freq / two$Freq[sb32]
    
    df2 <- two[sb2, ]
    df2$Prob <- df2$Freq * 0.4 / one$Freq[sb21]
    
    dfall <- merge(df3, df2, all = TRUE)
    
    dfall <- dfall[order(dfall$Prob, decreasing = TRUE), ]
    
    word <- NULL
    for(i in 1:3){
        temp <- unlist(strsplit(as.character(dfall$Token[i]), "\\s"))
        word[i] <- temp[length(temp)]
    }
    print(word)
}

one <- word_one_order
two <- word_two_order
three <- word_three_order

x <- "i am"

sb_predict(x, one, two, three)





##---------------------------------twoword prediction updated--------------------------

twoword_predict <- function(x, one, two, three){
    se <- grep(paste0("^", x, "\\s"), three, perl = TRUE, value = FALSE)
    num <- length(se)
    word <- NULL
    i <- 1
    while(i <= 5 && i <= num){
        word[i] <- unlist(strsplit(as.character(three[se][i]), "\\s"))[3]
        i = i + 1
    }
    if(length(word) != 5){
        second <- strsplit(x, "\\s")[[1]][2]
        se <- grep(paste0("^", second, "\\s"), two, perl = TRUE, value = FALSE)
        num <- length(se)
        len <- length(word)
        while(i <= 5 && i <= num + len){
            temp <- unlist(strsplit(as.character(two[se][i - len]), "\\s"))[3]
            k <- 1
            while(length(grep(temp, word, perl = TRUE, value = FALSE)) != 0){
                temp <- unlist(strsplit(as.character(two[se][i - len + k]), "\\s"))[3]
                k = k + 1
            }
            word[i] <- temp
            i = i + 1
        }
        if(length(word) != 5){
            j <- 0
            len <- length(word)
            while(i <= 5){
                word[i] <- as.character(one[1 + j])
                i <- i + 1
                j <- j + 1
            }
        }
    }
    print(word)
    
}



setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Data/Tokens")

load("token_one.RData")
load("token_two.RData")
load("token_three.RData")

one <- as.character(token_one$Token[1:10000])
two <- as.character(token_two$Token[1:10000])
three <- as.character(token_three$Token[1:10000])

## save data to shiny 

setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Shiny")
save(one, file = "one.RData")
save(two, file = "two.RData")
save(three, file = "three.RData")


x <- "some of"

twoword_predict(x, one, two, three)


##----------------------one_word predict learning--------------------------

token <- function(x, num, two_learn){
    Token <- NGramTokenizer(x, Weka_control(min = num, max = num))
    word_two <- data.frame(table(Token))
    word_two_order <- word_two[order(word_two$Freq, decreasing = TRUE), ]
    
    two_learn <- merge(two_learn, word_two_order, by = "Token", all = TRUE)
    two_learn[is.na(two_learn)] <- 0
    two_learn$SUM <- apply(two_learn[, c("Freq.x", "Freq.y")], 1, sum)
    two_learn <- subset(two_learn, select = c("Token", "SUM"))
    colnames(two_learn) <- c("Token", "Freq")
    return(two_learn)
}

tmp <- proc.time()

x <- tolower(x)
sp <- unlist(strsplit(as.character(x), ""))
y <- unlist(strsplit(as.character(x), "\\s")) 
if(sp[length(sp)] == " "){
    if(length(y) == 0){
        next
    }else if(length(y) == 1){
        y <- paste(y, collapse = " ")
        one_learn <- token(y, 1, one_learn)
    }else if(length(y) == 2){
        y <- paste(y, collapse = " ")
        one_learn <- token(y, 1, one_learn)
        two_learn <- token(y, 2, two_learn)
    }else if(length(y) == 3){
        y <- paste(y, collapse = " ")
        one_learn <- token(y, 1, one_learn)
        two_learn <- token(y, 2, two_learn)
        three_learn <- token(y, 3, three_learn)
    }else{
        y[-1:-(length(y) - 3)]
        y <- paste(y, collapse = " ")
        one_learn <- token(y, 1, one_learn)
        two_learn <- token(y, 2, two_learn)
        three_learn <- token(y, 3, three_learn)
    }
}



proc.time() - tmp


