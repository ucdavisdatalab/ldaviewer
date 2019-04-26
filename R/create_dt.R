# var doctopics = [
#{'name':'filename1', 'scores':[0.04,...], 'topics':[2,3,41,2...]},
#{...}
#]
# 'count' =15
# top 'count' topics per document
# x is doc topics or sample of doc topics
# assumes small enough to handle
create_dt = function(x, fnames, count=3)
{
    result = "var doctopics = ["
    indsorted = t(apply(x, 1, order, decreasing=TRUE))
    
    for (i in 1:nrow(indsorted))
    {
        inds = indsorted[i,]
        scores = (x[i,][inds][1:count])
        topics = inds[1:count]
        
        name = paste0("'name':", fnames[i])
        rscores = paste0("'scores':",toJSON(scores))
        rtopics = paste0("'topics':", toJSON(topics))
        res = paste0('{', name, ',', rscores, ',', rtopics,'}')
        if (i < nrow(indsorted))
        {
            res = paste0(res,",\n")
        }
        result = paste0(result,res)
    }
    result = paste0(result,"];")
    return (result)
}
