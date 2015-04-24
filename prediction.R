oneword_predict <- function(x, one, two){
    se <- grep(paste0("^", x, "\\s"), two, perl = TRUE, value = FALSE)
    if(length(se) == 0){
        print(c(as.character(one[1]), as.character(one[2]), as.character(one[3]), as.character(one[4]), as.character(one[5]), as.character(one[6]), as.character(one[7]), as.character(one[8]), as.character(one[9]), as.character(one[10])))
    }else{
        num <- length(se)
        word <- NULL
        i <- 1
        while(i <= 10 && i <= num){
            word[i] <- unlist(strsplit(as.character(two[se][i]), "\\s"))[2]
            i = i + 1
        }
        return(word)
    }
}


twoword_predict <- function(x, one, two, three){
    se <- grep(paste0("^", x, "\\s"), three, perl = TRUE, value = FALSE)
    num <- length(se)
    word <- NULL
    i <- 1
    while(i <= 10 && i <= num){
        word[i] <- unlist(strsplit(as.character(three[se][i]), "\\s"))[3]
        i = i + 1
    }
    if(length(word) != 10){
        second <- strsplit(x, "\\s")[[1]][2]
        se <- grep(paste0("^", second, "\\s"), two, perl = TRUE, value = FALSE)
        num <- length(se)
        len <- length(word)
        while(i <= 10 && i <= num + len){
            word[i] <- unlist(strsplit(as.character(two[se][i - len]), "\\s"))[2]
            i = i + 1
        }
        if(length(word) != 10){
            j <- 0
            len <- length(word)
            while(i <= 10){
                word[i] <- as.character(one[1 + j])
                i <- i + 1
                j <- j + 1
            }
        }
    }
    return(word)
    
}


predict <- function(x, first, second, third){
    x <- tolower(x)
    y <- unlist(strsplit(as.character(x), "\\s"))
    if(length(y) == 0){
        y <- c("", "", "", "", "")
    }else if(length(y) == 1){
        y <- oneword_predict(y, first, second)
    }else if(length(y) == 2){
        y <- paste(y, collapse = " ")
        y <- twoword_predict(y, first, second, third)
    }else{
        y <- y[-1:-(length(y) - 2)]
        y <- paste(y, collapse = " ")
        y <- twoword_predict(y, first, second, third)
    }
    return(y)
}


token <- function(x, num, two_learn){
    Token <- NGramTokenizer(x, Weka_control(min = num, max = num))
    word_two <- data.frame(table(Token))
    word_two_order <- word_two[order(word_two$Freq, decreasing = TRUE), ]
    
    two_learn <- merge(two_learn, word_two_order, by = "Token", all = TRUE)
    two_learn[is.na(two_learn)] <- 0
    two_learn$SUM <- apply(two_learn[, c("Freq.x", "Freq.y")], 1, sum)
    two_learn <- subset(two_learn, select = c("Token", "SUM"))
    colnames(two_learn) <- c("Token", "Freq")
    two_learn <- two_learn[order(two_learn$Freq, decreasing = TRUE), ]
    return(two_learn)
}

