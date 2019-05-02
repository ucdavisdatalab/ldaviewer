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
#' @param ldavisJSON **optional A string containing the json data generated with createJSON from the LDAvispackage.
#' @param metainfo **optional** A string that you want to place in index.html to record some details
#'	  about the model.
#' @param verbose **optional** A bool, displays some extra prints if set to TRUE, default=FALSE.
#' @return A string that is the path to the directory containing the site
#'
#' @examples
#' \dontrun{
#' create_viewer(dt,tt,v,f, "./texts", "./site/")
#' create_viewer(dt,tt,v,f, "./texts", "./site/", ldavisJSON=myjson)
#' create_viewer(dt,tt,v,f, "./texts", "./site/", metainfo="alpha=.05 beta=0.1")
#' create_viewer(dt,tt,v,f, "./texts", "./site/", verbose=TRUE)
#'}
#' @export
create_viewer = function(dt,tt,vocab,fnames,textpath, odir, ldavisJSON="", metainfo="", verbose=FALSE)
{

    # ============== CHECK INPUT DATA =============================
    filenames = sapply(fnames, basename, USE.NAMES=FALSE)
    files = paste0(textpath, filenames)
    K = ncol(dt)
    D = length(files)
    V = length(vocab)

    if (V != ncol(tt))
    {
	warnings("number of unique terms doesn't match number of terms in topic terms matrix")
    }
    if (D != nrow(dt))
    {
	warnings("number of documents doesn't match number of documents in doc topics matrix")
    }
    if (D > 50000)
    {
	warning("Number of documents is very high. You probably want to sample dt before running this!")
    }


    # ============== CREATE OUTPUT DIRECTORY ======================
    if (dir.exists(odir))
    {
	unlink(odir, recursive=TRUE)
    }
    dir.create(odir)
    datadir = paste0(odir, "/data/")
    dir.create(datadir)

    # ============== CREATE JS DATA ===============================
    if (verbose) {print("creating dt_small")}
    dt_small = create_dt(dt)
    if (verbose) {print("creating td_small")}
    td_small = create_td(dt)
    if (verbose) {print("creating tt_small")}
    tt_small = create_tt(tt)

    # create filenames json
    jsfnames = jsonlite::toJSON(fnames)
    jsfnames = paste0("var fnames=", jsfnames, ";")

    # create vocab json
    jsvocab = jsonlite::toJSON(vocab)
    jsvocab = paste0("var vocab=",jsvocab,";")

    # create file contents json
    jsfile_contents = create_file_contents(files)

    # =============== WRITE DATA TO OUTPUT/DATA DIRECTORY =========
    if (verbose) {print("writing to odir")}
    cat(dt_small, file = file.path(datadir, "dt_small.js"))
    cat(td_small, file = file.path(datadir, "td_small.js"))
    cat(tt_small, file = file.path(datadir, "tt_small.js"))
    cat(jsfnames, file = file.path(datadir, "fnames.js"))
    cat(jsvocab, file = file.path(datadir, "vocab.js"))
    cat(jsfile_contents, file= file.path(datadir, "file_contents.js"))



    # =============== COPY SITE FILES TO OUTPUT DIRECTORY =========
    # copy static files over
    srcdir = system.file("htmljscss/ldaviewer/", package="ldaviewerDSI")
    file.copy(list.files(srcdir,full.names=TRUE, recursive=TRUE), odir, recursive=TRUE)

    if (ldavisJSON != "") 
    {
        if (verbose) {print("adding ldavis pages")}
        # copy extra files over (lda.css, ldavis.js, ldavis.html)
        srcdir = system.file("htmljscss/ldavis/", package="ldaviewerDSI")
        file.copy(list.files(srcdir, full.names=TRUE, recursive=TRUE), odir)

	# copy ldavispath to /data/lda.json
	cat(ldavisJSON, file = file.path(datadir, "lda.json"))

        # modify index.html, doctopics.html, topicdocs.html to have link to ldavis.html
        # append <a href="ldavis.html">ldavis</a> to <div class="nav">
	pages = c("index.html", "doctopics.html", "topicdocs.html")
	fullpages = paste(odir, pages, sep="/")
	lapply(fullpages,add_nav_link)
    }


    # =============== EDIT INDEX.HTML TO HAVE LDA INFO ============
    # edit the index.html <p id="ldainfo"></p> to have info about the topic model
    infostring = paste("K =",K,"D =", D,"V =",V, metainfo,sep=" ")
    ipath = paste(odir,"index.html",sep="/")
    add_info_string(ipath, infostring)

    return (odir)
}

add_nav_link = function(file)
{
    html = xml2::read_html(file)
    navdiv = xml2::xml_find_first(html, "//div[@class='nav']")

    newdoc = xml2::read_html('<a href="ldavis.html">ldavis</a>')
    newline = xml2::xml_find_first(newdoc, "//a")
    xml2::xml_add_child(navdiv, newline)
    xml2::write_html(html, file)
}

add_info_string = function(file, infostring)
{
    # note only works on index file
    index = xml2::read_html(file)
    ldainfo = xml2::xml_find_first(index, "//p[@id='ldainfo']")
    xml2::xml_text(ldainfo) = infostring
    xml2::write_html(index, file)
}
