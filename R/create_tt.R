#' Create Small Topic Terms JSON
#' 
#' A function to create a string containing the topic terms array.
#' Takes as input the topic terms array and the vocab.
#' Output string has this format: var topicterms = [
#' {'name':1, 'scores':[0.04,...], 'terms':['word1", "word2",...]},
#' {...}
#' ]
#' @param x A topic term matrix.
#' @param fnames A character vector of vocab with length = ncols(x)
#' @param count **optional** Number of terms per topic to store, default=200)
#' @return A string containing the JSON.
#' 
#' @examples
#' \dontrun{
#' dt_small = create_dt(dt, vocab)
#' dt_small = create_dt(dt, vocab, 100)
#' }
#' @export
create_tt = function(x, vocab, count=200)
{
    result = "var topicterms = ["
    indsorted = t(apply(x, 1, order, decreasing=TRUE))
    
    for (i in 1:nrow(indsorted))
    {
        inds = indsorted[i,]
        scores = (x[i,][inds][1:count])
        terms = (vocab[inds][1:count])
        
        name = paste0("'name':", i)
        rscores = paste0("'scores':",jsonlite::toJSON(scores))
        rterms = paste0("'terms':", jsonlite::toJSON(terms))
        res = paste0('{', name, ',', rscores, ',', rterms,'}')
        if (i < nrow(indsorted))
        {
            res = paste0(res,",\n")
        }
        result = paste0(result,res)
    }
    result = paste0(result,"]:")
    return (result)
}

