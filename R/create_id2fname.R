#' Create ID to Filename array JSON
#' 
#' A function to create a string containing a table linking int id with fname in JSON.
#' Takes as input the filenames vector.
#' Output string has this format: var id2fname = [
#' {'id':1, 'fname':"file1"},
#' {...}
#' ];
#' @param fnames A character vector of vocab with length = ncols(x)
#' @return A string containing the JSON.
#' 
#' @examples
#' \dontrun{
#' id2fnames = create_id2fnames(fnames)
#' }
#' @export
create_id2fname = function(fnames)
{
    result = "var id2fname = ["
    
    for (i in 1:length(fnames))
    {
        id = i
        fname = fnames[i]
        
        res = paste0('{',"'id':", '"', fname, '"', '}')

        if (i < length(fnames))
        {
            res = paste0(res,",\n")
        }
        result = paste0(result,res)
    }
    result = paste0(result,"];")
    return (result)
}

