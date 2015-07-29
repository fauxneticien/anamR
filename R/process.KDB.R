#' Process data from the KDB hierarchy
#'
#' This function performs a number of cleaning and organisation routines to data from KDB.txt. Indiciate whether a routine should or not be performed by adjusting the TRUE/FALSE flags below.
#' @param KDB The KDB data frame returned from read.KDB()
#' @param remove_initial_spaces Remove space indents from the content data
#' @param extract_tags Extract dictionary codes into a 'tag' column
#' @param make_lx_ids Assign a unique sequential integer to each lx item in the dictionary data
#' @param remove_empty_lines Remove lines with only spaces. Default is FALSE for retaining human readibility. Suggest TRUE when doing processing to down size the data frame.
#' @export
#' @import dplyr
#' @importFrom zoo na.locf
#' @importFrom stringr str_extract str_replace
#' @examples
#' process.KDB(read.KDB())
#'
#' KDB <- read.KDB(process_data = FALSE)
#' KDB <- process.KDB(KDB)
#'
#' KDB <- process.KDB(KDB, remove_emptylines = TRUE)

process.KDB <- function(KDB,
                        remove_initial_spaces = TRUE,
                        extract_tags = TRUE,
                        make_lx_ids = TRUE,
                        remove_emptylines = FALSE) {

    if(remove_emptylines == TRUE) {
        KDB <- mutate(KDB,
                      nonspace_n = str_replace_all(content, "\\s+", ""),
                      nonspace_n = nchar(nonspace_n)) %>%
            filter(nonspace_n != 0)
    }

    if(extract_tags == TRUE) {
        KDB <- mutate(KDB,
                      tag = str_extract(content, "\\\\[a-z]+"),
                      tag = str_replace(tag, "\\\\", "")) %>%
            select(lineno, indent, tag, content)
    }

    if(remove_initial_spaces == TRUE) {
        KDB <- mutate(KDB,
                      content = str_replace(content, "^\\s*\\\\[a-z]+\\s?", ""))
    }

    if(make_lx_ids == TRUE) {
        KDB <- filter(KDB, tag == "lx") %>%
            select(lineno) %>%
            mutate(lx_id = 1:n()) %>%
            left_join(KDB, ., by = "lineno") %>%
            # filter(tag != "sk") %>%
            select(lineno, lx_id) %>%
            mutate(lx_id = na.locf(lx_id,
                                   na.rm = FALSE)) %>%
            left_join(KDB, ., by = "lineno")

    }

    KDB
}
