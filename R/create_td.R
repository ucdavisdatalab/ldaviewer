#' Create Topics Docs JSON
#' 
#' A function to create a string containing one array which has
#' has the top docs per topic. 
#' If doc topics is incredibly large, then just pass a sample.
#' Output string has this format: 
#' var td_inds = [11,23...];
#' @param x A doc topic matrix.
#' @param count **optional** Number of documents per document to store, default=15)
#' @return A string containing the JSON.
#' 
#' @examples
#' \dontrun{
#' td_small = create_td(dt) 
#' td_small = create_td(dt, 20) 
#' }
create_td = function(x, count=15)
{

    I = t(apply(x, 2, order, decreasing=TRUE))
    I = I[,1:count]

    inds = jsonlite::toJSON(I)

    result = paste0("var td_inds=",inds,";\n")
    return (result)
}
