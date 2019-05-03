#' Load Texts
#' 
#' A function to create a vector containing the first X characters
#' of each document given a vector of filenames. If a single file is passed
#' then the function assumes each line has a different document.
#' If for whatever reason the file can't be read from (doesn't exist or lack of permissions)
#' the string for that doc will be blank. 
#' @param files A string vector of filenames or a single file name.
#' @param nchars **optional** Number of characters per document to store.
#' @return A character vector of the first nchars from each file 
#' 
#' @examples
#' \dontrun{
#' file_contents = load_texts(files)
#' file_contents = load_texts(files, 1000)
#' }
#' @export
load_texts = function(files, nchars=3000)
{
    if (length(files) > 2)
    {
        text_list = lapply (files, protected_readChar_files, nchars)
        text_vec = unlist(text_list, use.names=FALSE)
        return(text_vec)
    }
    else
    {
	texts = readLines(files)
	texts = lapply(texts, substr, 1,nchars)
	text_vec = unlist(texts, use.names=FALSE)
        return(text_vec)
    }
}

protected_readChar_files = function(file, nchars)
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
