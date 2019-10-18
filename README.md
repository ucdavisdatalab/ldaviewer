# Lda Viewer DSI

This package generates a website that allows the user to dynamically explore the results of a topic model. It takes as basic input the document topics matrix and topic terms matrix. The view provides a way to measure how well the model fit the documents in the corpus. In addition, it can easily be combined with the **LDAvis** package. 

**ldaviewerDSI** does not run the topic model or create the JSON for **LDAvis**. It is meant to be run on the results of a topic model. To link it with **LDAvis** you need to provide an already created json file with the data required for **LDAvis**. 

View an example at [ds.lib.ucdavis.edu/text-report/ldaviewer/](http://ds.lib.ucdavis.edu:/text-report/ldaviewer/).

## Installation Instructions

Clone the bitbucket repository. Through the command line run R CMD build and R CMD INSTALL. When installed refer to the **quick start** and **reference** pages to see how to use it. When installed it can be loaded in library(ldaviewerDSI).

Alternatively install through bitbucket or github with devtools.
```{r}
devtools::install_github("ucdavisdatalab/ldaviewer")
```

## Usage

Create the data necessary for the site from the results of your topic model.

```{r}
json = build_website_json(topic_terms, doc_topics, vocab, fnames, texts)
```

With the data build the website into the output directory specified.

```{r}
build_website(json, "./outputdir/")
```

## Making modifications to this package

This package has a simple work flow: process the data in R, pass that data to the javascript that drives the visualizations. The package structure reflects this. All of the javascript,html, and css is placed in the /inst/ directory. The R code is in the /R/ directory. The main function of this package, **build_website()** creates the data necessary for the visuals, and then copies over the webpages (that link to this created data) to the output directory.

 If you want to modify this package to change its existing visuals or to add new ones, you need to be aware of this work flow to know where to put your code. If you want to add additional visualizations  you need to add extra javascript and html to /inst/. Then, to have the data necessary for your new visuals, you need to add R code to create a JavaScript friendly representation of that data. Finally, modify the **build_website()** to save your data in the output directory, and copy over your new web pages.

## Contact

To contact the maintainer email Arthur Koehl at avkoehl at ucdavis.edu
