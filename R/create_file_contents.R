#' Create File Contents JSON
#' 
#' A function to create a string containing the first X characters
#' of each file given a vector of filenames. If for whatever reason
#' the file can't be read from (doesn't exist or lack of permissions)
#' the string for that file will be blank. 
#' Output string has this format: 
#' var file_contents = ["file 1 contents", "more text here", ...];
#' @param files A string vector of filenames
#' @param nchars **optional** Number of characters per document to store.
#' @return A string containing the JSON.
#' 
#' @examples
#' \dontrun{
#' file_contents = create_file_contents(files)
#' file_contents = create_file_contents(files, 1000)
#' }
#' @export
create_file_contents = function(files, nchars=3000)
{
    text_list = lapply (files, protected_readChar, nchars)
    text_vec = unlist(text_list, use.names=FALSE)
    result = jsonlite::toJSON(text_vec)
    result = paste0("var file_contents = ", result, ";")
    return (result)
}

protected_readChar = function(file, nchars)
{
    result = tryCatch({
	text = readChar(file,nchars)
    }, error = function(e) {
	text = ""
    }, finally = {
	result = text
    })
    return (result)
}
