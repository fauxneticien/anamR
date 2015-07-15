#' Read in data from KDB.txt
#'
#' This function reads in the data from KDB.txt and processes them into a data frame.
#' @param file_loc Specify where KDB.txt is, this defaults to ~/Documents/GitHub/KDB/KDB.txt
#' @keywords cats
#' @export
#' @examples
#' read.KDB()
#' KDB <- read.KDB()
#' read.KDB("~/Desktop/KDB_copy.txt")

read.KDB <- function(file_loc = "~/Documents/GitHub/KDB/KDB.txt", process_data = TRUE) {
    raw <- unlist(readLines(file_loc))

    KDB <- data.frame(lineno = 1:length(raw),
                      indent = nchar(stringr::str_extract(raw, "^\\s*")),
                      content = raw,
                      stringsAsFactors = FALSE)

    if(process_data == TRUE) {
        process.KDB(KDB)
    } else {
        KDB
    }

}
