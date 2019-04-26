# expects as input a topic terms matrix
# for each topic get the top 200 words
# create js object of format:
# var topicterms = [{'name': 1, 'scores': [0.03,...], 'terms': ['particle', 'atmostphere',...}, {...}];
create_tt = function(x, vocab, count=3)
{
    result = "var topicterms = ["
    indsorted = t(apply(x, 1, order, decreasing=TRUE))
    
    for (i in 1:nrow(indsorted))
    {
        inds = indsorted[i,]
        scores = (x[i,][inds][1:count])
        terms = (vocab[inds][1:count])
        
        name = paste0("'name':", i)
        rscores = paste0("'scores':",toJSON(scores))
        rterms = paste0("'terms':", toJSON(terms))
        res = paste0('{', name, ',', rscores, ',', rterms,'}')
        if (i < nrow(indsorted))
        {
            res = paste0(res,",\n")
        }
        result = paste0(result,res)
    }
    result = paste0(result,"]:")
    return (result)
}

