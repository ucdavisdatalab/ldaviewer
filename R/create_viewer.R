#' Create LDA viewer Site
#'
#' The function that creates the ldaviewer website.
#' Reads in the doc topics and topic terms array,
#' runs them through the appropriate functions to create
#' the js files necessary for the site. Moves those files and
#' the files in /inst/ to the output directory.
#' Optionally can be passed the lda.json data created by 
#' createJSON from ldavis. If so, will add that page to the site.
#'
#' @param dt A doc topic matrix.
#' @param tt A topic terms matrix.
#' @param vocab A vector of the vocab length = ncols(tt)
#' @param fnames A vector of the filenames length = nrows(dt)
#' @param textpath A string containing the path to the directory containing
#'        all the text files.
#' @param odir A string containing the path to create the website in.
#' @param ldavispath **optional A string containing the path to the lda.json file.
#'	  if not empty then ldavis will be included in the site.
#' @param verbose **optional** A bool, displays some extra prints if set to TRUE, default=FALSE.
#' @return A string that is the path to the directory containing the site
#'
#' @examples
#' \dontrun{
#' create_viewer(dt,tt,vocab,fnames, "./texts", "./site/", "./jda.json"
#' create_viewer(dt,tt,vocab,fnames, "./texts", "./site/")
#'}
#' @export
create_viewer = function(dt,tt,vocab,fnames,textpath, odir, ldavispath="", verbose=FALSE)
{
    # get data
    if (verbose) {print("creating dt_small")}
    dt_small = create_dt(dt, fnames)
    if (verbose) {print("creating td_small")}
    td_small = create_td(dt, fnames)
    if (verbose) {print("creating tt_small")}
    tt_small = create_tt(tt, vocab)

    # create filenames json
    fnames = jsonlite::toJSON(fnames)
    fnames = paste0("var fnames:", fnames, ";")

    # make output directory
    if (dir.exists(odir))
    {
	unlink(odir, recursive=TRUE)
    }
    dir.create(odir)

    datadir = paste0(odir, "/data/")
    dir.create(datadir)


    if (verbose) {print("writing to odir")}
    # write to output directory
    con = file(file.path(datadir, "dt_small.js"))
    cat(dt_small, file=con)
    close.connection(con)
    con = file(file.path(datadir, "td_small.js"))
    cat(td_small, file=con)
    close.connection(con)
    con = file(file.path(datadir, "tt_small.js"))
    cat(tt_small, file=con)
    close.connection(con)
    con = file(file.path(datadir, "fnames.js"))
    cat(fnames, file=con)
    close.connection(con)


    # copy texts over
    if (verbose) {print("copying files over")}
    file.copy(textpath, datadir, recursive=TRUE)

    if (ldavispath == "")
    {
	    # copy static files over
        srcdir = system.file("htmljscss/noldavis/", package="ldaviewerDSI")
        file.copy(list.files(srcdir,full.names=TRUE, recursive=TRUE), odir, recursive=TRUE)

    } 

    else 
    {
	    # copy static files over with the ldavis
        srcdir = system.file("htmljscss/withldavis/", package="ldaviewerDSI")
        file.copy(list.files(srcdir, full.names=TRUE, recursive=TRUE), odir, recursive=TRUE)
    }
    return (odir)
}
