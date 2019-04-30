#' Create Doc Topics JSON
#' 
#' A function to create a string containing two arrays. First array
#' has the top topics per doc. Second has the scores for those topics.
#' If doc topics is incredibly large, then just pass a sample.
#' Output string has this format: 
#' var inds = [11,23...];
#' var scores = [0.04,0.02,...];
#' @param x A doc topic matrix.
#' @param fnames A character vector of filenames with length = nrows(x)
#' @param count **optional** Number of topics per document to store, default=15)
#' @return A string containing the JSON.
#' 
#' @examples
#' \dontrun{
#' dt_small = create_dt(dt) 
#' }
#' @export
create_dt = function(x, count=15)
{

    I = t(apply(x, 1, order, decreasing=TRUE))
    I = I[,1:count]
    S = t(apply(x, 1, sort, decreasing=TRUE))
    S = S[,1:count]

    inds = jsonlite::toJSON(I)
    scores = jsonlite::toJSON(S)

    str_inds = paste0("var dt_inds=",inds,";\n")
    str_scores = paste0("var dt_scores=",scores,";")
    result = paste0(str_inds,str_scores)
    
    return (result)
}
