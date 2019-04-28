#' Create Small Doc Topics JSON
#' 
#' A function to create a string containing the doc topics array.
#' Takes as input the doc topics array and the names of the files.
#' If doc topics is incredibly large, then just pass a sample
#' to this punction and the filenames for that sample.
#' Output string has this format: var doctopics = [
#' {'name':'filename1', 'scores':[0.04,...], 'topics':[2,3,41,2...]},
#' {...}
#' ]
#' @param x A doc topic matrix.
#' @param fnames A character vector of filenames with length = nrows(x)
#' @param count **optional** Number of topics per document to store, default=15)
#' @return A string containing the JSON.
#' 
#' @examples
#' \dontrun{
#' dt_small = create_dt(dt, fnames)
#' dt_small = create_dt(dt, fnames, 20)
#' }
#' @export
create_dt = function(x, fnames, count=15)
{
    result = "var doctopics = ["

    dt.list = lapply(seq_len(nrow(x)), function(i) x[i,])
    indsorted = lapply(dt.list, order, decreasing=TRUE)
    
    for (i in 1:length(indsorted))
    {
        inds = unlist(indsorted[i], use.names=FALSE)
        scores = (x[i,][inds][1:count])
        topics = inds[1:count]
        
        n = paste0('"',fnames[1],'"')
        name = paste0("'name':", n)
        rscores = paste0("'scores':",jsonlite::toJSON(scores))
        rtopics = paste0("'topics':", jsonlite::toJSON(topics))
        res = paste0('{', name, ',', rscores, ',', rtopics,'}')
        if (i < length(indsorted))
        {
            res = paste0(res,",\n")
        }
        result = paste0(result,res)
    }
    result = paste0(result,"];")
    return (result)
}
