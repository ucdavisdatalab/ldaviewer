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
    indsorted = t(apply(x, 1, order, decreasing=TRUE))
    
    for (i in 1:nrow(indsorted))
    {
        inds = indsorted[i,]
        scores = (x[i,][inds][1:count])
        topics = inds[1:count]
        
        name = paste0("'name':", fnames[i])
        rscores = paste0("'scores':",jsonlite::toJSON(scores))
        rtopics = paste0("'topics':", jsonlite::toJSON(topics))
        res = paste0('{', name, ',', rscores, ',', rtopics,'}')
        if (i < nrow(indsorted))
        {
            res = paste0(res,",\n")
        }
        result = paste0(result,res)
    }
    result = paste0(result,"];")
    return (result)
}
