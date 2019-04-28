// given topic id
// get the top 5 docs and scores from topdocs.js
// for each doc, get the text from corpus.dat and store into strings
// create a div for each doc and set the inner html to the doc string

function load_docs() {
  document.getElementById("main").innerHTML = "";
  document.getElementById("termstopic").innerHTML = "";
  var t_id = document.getElementById("topic").value;
  var index = t_id -1;
  var data = topicdocs[index];
  var name = data["name"];
  var docs = data["docs"].slice(0,3);



  //---------------------LOAD TOPIC TERMS --------------------------//
  console.log("loading in topic terms");
  topicdata = topicterms[index]; //from tt_small.js
  var nterms = 50;
  t1 = []; //global var
  for (var i = 0; i < nterms; i++)
  {
    var t = topicdata["terms"][i];
    t1.push(t)
  }
  // load terms into tterms box
  var terms = t1.join(' ');
  var tdiv = document.getElementById("termstopic");
  var termstopic = document.createElement("p");
  termstopic.innerHTML = terms;
  tdiv.appendChild(termstopic);

  for (var i = 0; i < docs.length; i++)
  {
    var div = document.createElement("div");
    div.id = docs[i];
    div.style.margin = "10px auto";
    div.style.padding = "10px";
    document.getElementById("main").appendChild(div);
    textp = document.createElement("p");
    textp.id= docs[i] + "_text";
    var title = document.createElement("h3");
    title.innerHTML = get_title(docs[i]);
    div.appendChild(title);
    div.appendChild(textp);

    fname = docs[i] + ".txt";
    ajax_request_load_file(fname, textp);
  }

}

function get_title(uid) {
  //from uid get the tile
  var title = "";
  for (var i in filenames) {
    if (filenames[i] == uid) {
      var title = i;
    }
  }
  return title;
}



function ajax_request_load_file(fname, textp) {
  var base ="./data/text/";
  var http = new XMLHttpRequest();

  http.onreadystatechange = function() {
    if (http.readyState == 4) {
      if (http.status = 200) {
	callback(http.responseText, textp);
      }
      else {
	console.log("failed to load file");
      }
    }
  };

  http.open("GET", base+fname);
  http.send();
}

function callback (response, textp) {
  console.log("parsing doc");
  var full = response;
  var words = full.split(" ");

  for (var i = 0; i < words.length; i++) {
    var wd = document.createElement("span");
    wd.innerHTML = words[i] + " ";
    if (t1.includes(words[i].toLowerCase())) {
      wd.className = "topic1";
    }
    textp.appendChild(wd);
  }
}
   
