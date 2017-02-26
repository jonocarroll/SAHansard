library(dplyr)
library(SAHansard)

toc <- hansard_toc(docid = "HANSARD-10-19934")
speakers <- toc$content %>% group_by(speaker = name.2) %>% summarise(spoke = n()) %>% arrange(desc(spoke)) %>% data.frame
topics <- toc$content %>% group_by(topic = name.1) %>% summarise(discussed = n()) %>% arrange(desc(discussed)) %>% data.frame

speakers_file <- "speakers_2016-12-07_HANSARD-10-19934.txt"
stargazer::stargazer(speakers, type = "text", summary = FALSE, out = speakers_file)

topics_file <- "topics_2016-12-07_HANSARD-10-19934.txt"
stargazer::stargazer(topics, type = "text", summary = FALSE, out = topics_file)

fragments_file <- "fragments_2016-12-07_HANSARD-10-19934.txt"
cat("", file = fragments_file)

for (h in unique(toc$content$docid)) {
    cat(" ----------- \n", file = fragments_file, append = TRUE)
    cat(h, "\n", file = fragments_file, append = TRUE)
    cat(" ----------- \n", file = fragments_file, append = TRUE)
    cat(hansard_fragment(h)$content, "\n", file = fragments_file, append = TRUE)
}
