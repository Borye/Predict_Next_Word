### Welcome to Predict Next Word

This is a web application for predict the next word based on previous phrases. You can input some words or sentence fragment, and this app will automatically predict your next word based on the given input. 

This app contains a dictionary which include lots English common phrases. The dictionary is builded by corpus, which provided by **SwiftKey** the smart keyboard company, using **N-gram** model. First, the original datasets were preprocessed and tokenized. After preprocessing, the *1-gram*, *2-gram* and *3-gram* models were generated based on the cleaned corpus. Finally, the prediction is complete by take your input and find the most likely *next word* in the three models. In this preprocess, **back off** method is used when the inputted words combination can't be found in models. For example, if a inputted two words phrase can't be found in the *3-gram* model, then it will take the last word of the phrase and search in the *2-gram* model. However if this phrase can't be found in any of this two  models, then this app will output the most frequent words in *1-gram* model instead.

Several settings are provided for you to improve user experience. 

 * You could choose whether let the app to adaptively learn your writing habit and output prediction based on both **build-in dictionary** and **your input** or not. 
 * This app could output up to five predicted words. You could decide by yourself how to rank the output, by **most likely** or **alphabetically**. 
 * You could also change the form of the output words. No matter you want them to be **upper case**, **lower case** or **first letter captalized**.
 * The number of output words is up to your choice (**1-5**).

Beside this, you could see a **wordcloud** which include your input. And you could also have a peek about the **build-in dictionary** if you are interested about it. 

The datasets for this project is provided by [HC Corpora](http://www.corpora.heliohost.org/). It could be downloaded in this website: [SwiftKey Dataset](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip)

The source code is available at [GitHub]()

Have fun with this app :)