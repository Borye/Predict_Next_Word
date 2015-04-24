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


