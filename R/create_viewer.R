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
#' @return A string that is the path to the directory containing the site
#'
#' @examples
#' \dontrun{
#' create_viewer(dt,tt,vocab,fnames, "./texts", "./site/", "./jda.json"
#' create_viewer(dt,tt,vocab,fnames, "./texts", "./site/")
#'}
create_viewer(dt,tt,vocab,fnames,textpath, odir, ldavispath="")
{
    # get data
    dt_small = create_dt(dt, fnames)
    td_small = create_td(td, fnames)
    tt_small = create_tt(tt, vocab)

    # make output directory
    if (dir.exists(odir))
    {
	unlink(odir, recursive=TRUE)
    }
    create.dir(odir)

    # write to output directory
    con = file(file.path(odir, "dt_small.js"))
    cat(dt_small, file=con)
    close.connection(con)
    con = file(file.path(odir, "td_small.js"))
    cat(td_small, file=con)
    close.connection(con)
    con = file(file.path(odir, "tt_small.js"))
    cat(tt_small, file=con)
    close.connection(con)

    srcdir = system.file("htmlcssjs", package="ldaviewerDSI")

    if (ldavispath == "")
    {
	# copy files over
    } 

    else 
    {
	# copy files over with the ldavis
    }
    return (odir)
}
