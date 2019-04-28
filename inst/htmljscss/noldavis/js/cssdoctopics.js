function load () {

  //---------------------------INIT ---------------------------------//
  // get the document id from the page
  //var doc_id = document.getElementById("document").value;
  doc_title = document.getElementById("document").value;
  doc_id = filenames[doc_title];
  console.log(doc_id);
  if (doc_id == undefined) {
    alert("doc: " + doc_title + "not found");
  }

  // clear the output divs -- topicterms and doctopicsdiv
  document.getElementById("termstopic1").innerHTML = "";
  document.getElementById("termstopic2").innerHTML = "";
  document.getElementById("termstopic3").innerHTML = "";
  document.getElementById("termstopic4").innerHTML = "";
  document.getElementById("termstopic5").innerHTML = "";
  document.getElementById("doctopics").innerHTML = "";

  // create hash array for the top five topics
  topic_hash_arrays = [];
  t1 = {};
  t2 = {};
  t3 = {};
  t4 = {};
  t5 = {};
  topic_hash_arrays.push(t1);
  topic_hash_arrays.push(t2);
  topic_hash_arrays.push(t3);
  topic_hash_arrays.push(t4);
  topic_hash_arrays.push(t5);


  //---------------------LOAD TOPIC TERMS --------------------------//
  // get the top 5 topics for the given document
  console.log("loading in hashes for each topic");
  for (var i =0; i < doctopics.length; i++){
    if (doctopics[i]["name"] == doc_id)
      index = i;
  }

  var docdata = doctopics[index];
  var ttermsdiv = document.getElementById("topicterms");

  // for each topic 1-5
  for (var i = 0; i < 5; i++) {
    var topic = docdata["topics"][i];
    var score = Number(docdata["scores"][i]).toFixed(4);

    // get top terms for that topic
    var tindex = topic - 1;
    var topicdata = topicterms[tindex];
    var nterms = 50; //300 is max
    var tt = []
    for (var j = 0; j < nterms; j++) {
      var t = topicdata["terms"][j];
      var s = Number(topicdata["scores"][j]).toFixed(4);
      topic_hash_arrays[i][t] = s;
      tt.push(t);
    } // for each term in the topic

    var text = tt.join(' ');
    var tdiv = document.getElementById("termstopic" + (i+1).toString());
    var tp = document.createElement("p");
    tp.innerHTML = text;
    tp.style.color="black";
    tdiv.classList.add("topic" + (i+1).toString());
    tdiv.appendChild(tp);
  }//for each top 5 topics fill the hash and add terms to page


  //--------------------AJAX GET DOCUMENT --------------------------//
  console.log("ajax request for document");
  fname = doc_id.toString() + ".txt";
  ajax_request_load_file(fname, callback);

}

function ajax_request_load_file(fname, callback) {
  var base ="./data/text/";
  var http = new XMLHttpRequest();

  http.onreadystatechange = function() {
    if (http.readyState == 4) {
      if (http.status = 200) {
	callback(http.responseText);
      }
      else {
	console.log("failed to load file");
      }
    }
  };

  http.open("GET", base+fname);
  http.send();
}

function callback (response)
{
  console.log("parsing doc");
  var full = response;
  var words = full.split(" ");

  console.log("for word in doc assigning class if needed");
  for (var i = 0; i < words.length; i++) {
    wd = document.createElement("span");
    wd.innerHTML = words[i] + " ";

    //check to see if word is in one or more of the hashes and get one with highest score
    topt = -1;
    bestscore = 0;
    for (var j = 0; j < 5; j++) {
      word = words[i].toLowerCase();
      if (word in topic_hash_arrays[j]) {
	score = topic_hash_arrays[j][word]
	if (score > bestscore) {
	  bestscore = score;
	  topt = j;
	}//if
      }//if
    }//for each topic

    // give it classname equal to topic if one existed
    if (topt != -1) {
      wd.className = "topic" + (topt + 1).toString();
    }

    //append to the doctopicsdiv div
    dtd = document.getElementById("doctopics");
    dtd.appendChild(wd);
  }//for each word
}



      


