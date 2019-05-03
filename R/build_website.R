#' Create LDA viewer Site
#'
#' The function that creates the ldaviewer website.
#' Reads in the json data from build_website_json and writes
#' it to the output directory along with the html/js/css from /inst/.
#' Optionally can be passed the lda.json data created by 
#' createJSON from ldavis. If so, will add that page to the site.
#'
#' @param viewerJSON A string containing the json data built with build_website_json
#' @param odir A string containing the path to create the website in.
#' @param ldavis **optional A string containing the json data generated with createJSON from the LDAvispackage.
#' @param info **optional** A string that you want to place in index.html to record some details
#'	  about the model.
#' @return A string that is the path to the directory containing the site
#'
#' @examples
#' \dontrun{
#' build_website(viewerjson, "./site/")
#' build_website(viewerjson, "./site/", ldavis=myjson)
#' build_website(viewerjson, "./site/", info="alpha=.05 beta=0.1")
#'}
#' @export
build_website = function(json, odir, ldavis="", info="")
{

    # ============== CREATE OUTPUT DIRECTORY ======================
    if (dir.exists(odir))
    {
	unlink(odir, recursive=TRUE)
    }
    dir.create(odir)
    datadir = paste0(odir, "/data/")
    dir.create(datadir)


    # =============== WRITE DATA TO OUTPUT/DATA DIRECTORY =========
    cat(json, file= file.path(datadir, "viewer.js"))


    # =============== COPY SITE FILES TO OUTPUT DIRECTORY =========
    # copy static files over
    srcdir = system.file("htmljscss/ldaviewer/", package="ldaviewerDSI")
    file.copy(list.files(srcdir,full.names=TRUE, recursive=TRUE), odir, recursive=TRUE)

    if (ldavis != "") 
    {
        # copy extra files over (lda.css, ldavis.js, ldavis.html)
        srcdir = system.file("htmljscss/ldavis/", package="ldaviewerDSI")
        file.copy(list.files(srcdir, full.names=TRUE, recursive=TRUE), odir)

	# copy ldavispath to /data/lda.json
	cat(ldavis, file = file.path(datadir, "lda.json"))

        # modify index.html, doctopics.html, topicdocs.html to have link to ldavis.html
        # append <a href="ldavis.html">ldavis</a> to <div class="nav">
	pages = c("index.html", "doctopics.html", "topicdocs.html")
	fullpages = paste(odir, pages, sep="/")
	lapply(fullpages,add_nav_link)
    }


    # =============== EDIT INDEX.HTML TO HAVE LDA INFO ============
    # edit the index.html <p id="ldainfo"></p> to have info about the topic model
    ipath = paste(odir,"index.html",sep="/")
    add_info_string(ipath, info)

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
