#' Process data from the KDB hierarchy
#'
#' This function performs a number of cleaning and organisation routines to data from KDB.txt. Indiciate whether a routine should or not be performed by adjusting the TRUE/FALSE flags below.
#' @param KDB The KDB data frame returned from read.KDB()
#' @param remove_initial_spaces Remove space indents from the content data
#' @param extract_tags Extract dictionary codes into a 'tag' column
#' @param make_lx_ids Assign a unique sequential integer to each lx item in the dictionary data
#' @param remove_empty_lines Remove lines with only spaces. Default is FALSE for retaining human readibility. Suggest TRUE when doing processing to down size the data frame.
#' @keywords cats
#' @export
#' @importFrom magrittr "%>%"
#' @examples
#' read.KDB()
#' KDB <- read.KDB()
#' read.KDB("~/Desktop/KDB_copy.txt")

process.KDB <- function(KDB,
                        remove_initial_spaces = TRUE,
                        extract_tags = TRUE,
                        make_lx_ids = TRUE,
                        remove_emptylines = FALSE) {

    if(extract_tags == TRUE) {
        KDB <- dplyr::mutate(KDB,
                      tag = stringr::str_extract(content, "\\\\[a-z]+"),
                      tag = stringr::str_replace(tag, "\\\\", "")) %>%
                dplyr::select(lineno, indent, tag, content)
    }

    if(remove_initial_spaces == TRUE) {
        KDB <- dplyr::mutate(KDB,
                      content = stringr::str_replace(content, "^\\s*\\\\[a-z]+\\s", ""))
    }

    KDB
}
