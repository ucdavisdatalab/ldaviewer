#' Create Topic Terms JSON
#' 
#' A function to create a string containing the topic terms array.
#' Takes as input the topic terms array.
#' Output string has this format:
#' var inds = [21000,131,...];
#' var scores = [0.003, 0.002,...];
#' @param x A topic term matrix.
#' @param count **optional** Number of terms per topic to store, default=200)
#' @return A string containing the JSON.
#' 
#' @examples
#' \dontrun{
#' tt_small = create_tt(tt)
#' tt_small = create_tt(tt, 100)
#' }
#' @export
create_tt = function(x, vocab, count=200)
{
    I = t(apply(x, 1, order, decreasing=TRUE))
    I = I[,1:count]
    S = t(apply(x, 1, sort, decreasing=TRUE))
    S = S[,1:count]

    inds = jsonlite::toJSON(I)
    scores = jsonlite::toJSON(S)

    str_inds = paste0("var tt_inds=",inds,";\n")
    str_scores = paste0("var tt_scores=",scores,";")
    result = paste0(str_inds,str_scores)
    
    return (result)
}
