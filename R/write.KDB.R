#' Write KDB data frame to text file
#'
#' This function takes a KDB structured data frame in R and writes the data to a flat file.
#' @param file_loc Specify the text file to be written. Defaults should be ~/Documents/GitHub/KDB/KDB.txt but will leave this unspecified so the main file does not accidently get overwritten.
#' @param df Name of the KDB data frame, assumed to be KDB unless specified.
#' @export
#' @import dplyr
#' @examples
#' write.KDB(file_loc = "~/Documents/GitHub/KDB/KDB.txt")

write.KDB <- function(file_loc, df = KDB) {

    df$spaces <- sapply(df$indent, function(x) { paste0(rep(" ", x), collapse = '') })

    df$only_spaces <- nchar(str_replace_all(df$content, "\\s+", ""))
    df[which(df$only_spaces == 0 & is.na(df$tag)), 6] <- ""

    df$content <- paste0(df$spaces,
                         "\\",
                         df$tag,
                         " ",
                         df$content)

    df$content <- str_replace(df$content, "([a-z]+) $", "\\1")
    df$content <- str_replace(df$content, "\\\\NA ", "")

    writeLines(df$content, file_loc)

}
