#' Create Small Topic Docs JSON
#' 
#' A function to create a string containing the topic docs array.
#' Takes as input the doc topics array and the names of the files.
#' If doc topics is incredibly large, then just pass a sample
#' to this punction and the filenames for that sample.
#' Output string has this format: var topicdocs = [
#' {'name':1, 'scores':[0.04,...], 'docs':['filename1','filename2'...]},
#' {...}
#' ]
#' @param x A doc topic matrix.
#' @param fnames A character vector of filenames with length = nrows(x)
#' @param count **optional** Number of documents per topic to store, default=15)
#' @return A string containing the JSON.
#' 
#' @examples
#' \dontrun{
#' td_small = create_td(dt, fnames)
#' td_small = create_td(dt, fnames, 20)
#' }
#' @export
create_td = function(x, fnames, count=15)
{
    # pretty inefficient but fast enough since nrows is always small
    # conveniant output format in this sparse format so keeping it like this
    result = "var topicdocs = ["
    x = t(x)
    indsorted = t(apply(x, 1, order, decreasing=TRUE))
    for (i in 1:nrow(indsorted))
    {
        inds = indsorted[i,]
        scores = (x[i,][inds][1:count])
        docs = fnames[inds[1:count]]
        
        name = paste0("'name':", i)
        rscores = paste0("'scores':",jsonlite::toJSON(scores))
        rdocs = paste0("'docs':", jsonlite::toJSON(docs))
        res = paste0('{', name, ',', rscores, ',', rdocs,'}')
        if (i < nrow(indsorted))
        {
            res = paste0(res,",\n")
        }
        result = paste0(result,res)
    }
    result = paste0(result,"];")
    return (result)
}
