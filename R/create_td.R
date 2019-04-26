# top 'count' 15 docs per topic
#var topicterms = [
#       {'name':1, 'scores':[00.3,...], 'docs':['f3',]},
#       {...}
#   ];

create_td = function(x, fnames, count=3)
{
    result = "var topicdocs = ["
    x = t(x)
    indsorted = t(apply(x, 1, order, decreasing=TRUE))
    for (i in 1:nrow(indsorted))
    {
        inds = indsorted[i,]
        scores = (x[i,][inds][1:count])
        docs = fnames[inds[1:count]]
        
        name = paste0("'name':", i)
        rscores = paste0("'scores':",toJSON(scores))
        rdocs = paste0("'docs':", toJSON(docs))
        res = paste0('{', name, ',', rscores, ',', rdocs,'}')
        if (i < nrow(indsorted))
        {
            res = paste0(res,",\n")
        }
        result = paste0(result,res)
    }
    result = paste0(result,"];")
    return (result)
}
