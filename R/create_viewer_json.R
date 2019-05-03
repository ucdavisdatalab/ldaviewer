#' Create LDA viewer JSON
#'
#' Creates all the json data necessary for the ldaviewer site.
#' Reads in doc topics, topic terms, the file contents, filenames
#' and vocab.
#'
#' @param tt A topic terms matrix.
#' @param dt A doc topic matrix.
#' @param vocab A vector of the vocab length = ncols(tt)
#' @param fnames A vector of the filenames length = nrows(dt) and length(texts)
#' @param texts A character vector of the file contents. Can be genereated with the load_texts() function. 
#' @param verbose **optional** A bool, displays some extra prints if set to TRUE, default=FALSE.
#' @return A string containing the complete json for ldaviewer
#'
#' @examples
#' \dontrun{
#' myjson = create_viewer_json(tt,dt,v,f, docs)
#' myjson = create_viewer_json(tt,dt,v,f, docs, verbose=TRUE)
#'}
#' @export
create_viewer_json = function(tt,dt,vocab,fnames,texts,verbose=FALSE) 
{

    # ============== CHECK INPUT DATA =============================
    filenames = sapply(fnames, basename, USE.NAMES=FALSE)
    K = ncol(dt)
    D = length(filenames)
    V = length(vocab)

    if (V != ncol(tt))
    {
	warnings("number of unique terms doesn't match number of terms in topic terms matrix")
    }
    if (D != nrow(dt))
    {
	warnings("number of documents doesn't match number of documents in doc topics matrix")
    }
    if (D != length(texts))
    {
	warnings("number of documents doesn't match number of documents") 
    }
    if (D > 50000)
    {
	warning("Number of documents is very high. You probably want to sample dt before running this!")
    }

    # ============== CREATE JS DATA ===============================
    if (verbose) {print("creating dt_small")}
    dt_small = create_dt(dt)
    if (verbose) {print("creating td_small")}
    td_small = create_td(dt)
    if (verbose) {print("creating tt_small")}
    tt_small = create_tt(tt)

    # create filenames js
    jsfnames = jsonlite::toJSON(fnames)
    jsfnames = paste0("var fnames=", jsfnames, ";")

    # create vocab js
    jsvocab = jsonlite::toJSON(vocab)
    jsvocab = paste0("var vocab=",jsvocab,";")

    # create file contents js
    jsfile_contents = jsonlite::toJSON(texts)
    jsfile_contents = paste0("var file_contents = ", jsfile_contents, ";")

    viewer_json = paste(dt_small, td_small, tt_small, jsfnames, jsvocab, jsfile_contents, sep="\n")
    return (viewer_json)
}
