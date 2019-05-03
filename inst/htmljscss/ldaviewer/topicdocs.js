function load_topicdocs() {
    document.getElementById("main").innerHTML = "";
    document.getElementById("termstopic").innerHTML = "";
    create_topic_terms_box();
    create_documents();
}

function create_topic_terms_box() {
    var t_id = document.getElementById("topic").value;
    var index = t_id-1;
    var tt_ind = tt_inds[index];
    //---------------------LOAD TOPIC TERMS --------------------------//
    //console.log("loading in topic terms");
    var nterms = 50;
    t1 = []; //global var
    for (var i = 0; i < nterms; i++)
    {
	var t = vocab[tt_ind[i]-1];
	t1.push(t);
    }
    // load terms into tterms box
    var terms = t1.join(' ');
    var tdiv = document.getElementById("termstopic");
    var tdivtitle = document.createElement("h3");
    tdivtitle.innerHTML = "topic id: " + t_id;
    tdiv.appendChild(tdivtitle);
    var termstopic = document.createElement("p");
    termstopic.innerHTML = terms;
    tdiv.appendChild(termstopic);
}//create_topic_terms_box

function create_documents() {
    var t_id = document.getElementById("topic").value;
    var index = t_id-1;
    var td_ind = td_inds[index];
    docs = [];
    for (var i=0; i < 5; i++)
    {
	var d = td_ind[i]-1;
	docs.push(d);
    }

    maindiv = document.getElementById("main");
    for (var i = 0; i < docs.length; i++){
	doc_index = docs[i];
	doc_name = fnames[docs[i]];
	doc_text = file_contents[docs[i]];
	var textdiv = document.createElement("p");
	textdiv.id = doc_name;
	textdiv.style.margin = "10px auto";
	textdiv.style.padding = "10px";
	var title = document.createElement("h3");
	title.innerHTML = doc_name;
	textdiv.appendChild(title);

	var words = doc_text.replace(/\n/g, " ").split(" ");
	for (var j =0; j < Math.min(350,words.length); j++) {
	    var wd = document.createElement("span");
	    wd.innerHTML = words[j] + " ";
	    if (t1.includes(words[j].toLowerCase())) {
		wd.className = "topic1";
	    }//if word in topic
	    textdiv.appendChild(wd);
	}//for each word
	end = document.createElement("p");
	end.innerHTML = " ... ";
	end.style.textAlign="center";
	end.style.fontSize="xx-large";
	textdiv.appendChild(end);
	maindiv.appendChild(textdiv);
    }//for each document
}//create_documents
