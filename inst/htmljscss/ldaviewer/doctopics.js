function load() {
    documentSearch = document.getElementById("document").value;
    if (isNaN(documentSearch)) {
        doc_title = documentSearch;
        for (var i=0; i <fnames.length;i++){
            if (fnames[i] == doc_title){
                doc_index = i;
            }
        }

    } else {
        doc_index = documentSearch -1;
        doc_title = fnames[doc_index];
    }

    if (doc_title == undefined) {
        alert("doc: " + doc_title + "not found");
    }


    document.getElementById("doctitle").innerHTML = "";
    document.getElementById("doctitle").innerHTML = doc_title;
    document.getElementById("doctopics").innerHTML = "";
    document.getElementById("topicterms").innerHTML = "";

    create_doc_topics_bar();
    create_topic_terms_bar();
    create_css_doc_topics();

    d3.selectAll('.bar')
      .style('fill', "#1f77b4");
    return;
}

function create_doc_topics_bar () {
    document.getElementById("doctopics").innerHTML = "";

    docdata_inds = dt_inds[doc_index];
    docdata_scores = dt_scores[doc_index];

    var data = [];
    for (var i = 0; i < 15; i++) {
        var bar = {name:"Topic " + docdata_inds[i], value:Number(docdata_scores[i]).toFixed(3)};
        data.push(bar);
    }

    //sort bars based on value
    data = data.sort(function (a, b) {
        return d3.ascending(a.value, b.value);
    })
    document.getElementById("tid").innerHTML =Number(data[14]["name"].split(" ")[1]);

    //set up svg using margin conventions - we'll need plenty of room on the left for labels
    var margin = {
        top: 15,
        right: 60,
        bottom: 15,
        left: 65
    };

    var width = window.innerWidth * .35 - margin.left - margin.right,
        height = 500 - margin.top - margin.bottom;

    var svg = d3.select("#doctopics").append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
        .append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    var x = d3.scale.linear()
        .range([0, width])
        .domain([0, d3.max(data, function (d) {
            return d.value;
        })]);

    var y = d3.scale.ordinal()
        .rangeRoundBands([height, 0], .1)
        .domain(data.map(function (d) {
            return d.name;
        }));

    //make y axis to show bar names
    var yAxis = d3.svg.axis()
        .scale(y)
    //no tick marks
        .tickSize(0)
        .orient("left");

    var gy = svg.append("g")
        .attr("class", "y axis")
        .call(yAxis)

    var bars = svg.selectAll(".bar")
        .data(data)
        .enter()
        .append("g")

    //append rects
    bars.append("rect")
        .attr("class", "bar")
        .attr("y", function (d) {
            return y(d.name);
        })
        .on("click", function(d) {
            d3.selectAll('circle')
                .style('fill', "#1f77b4")
            elem = d.name.split(" ");
            document.getElementById("tid").innerHTML = elem[1];
            create_topic_terms_bar();
            //console.log("clicked " + elem[1]);
            //document.getElementById("lda-topic").value=elem[1] - 1;
            //document.getElementById("lda-topic-up").click();
            d3.selectAll('.bar')
                .style('fill', "#1f77b4");
            d3.select(this).style("fill", "#d62728");
        })
        .attr("height", y.rangeBand())
        .attr("x", 0)
        .attr("width", function (d) {
            return x(d.value);
        });

    //add a value label to the right of each bar
    bars.append("text")
        .attr("class", "label")
    //y position of the label is halfway down the bar
        .attr("y", function (d) {
            return y(d.name) + y.rangeBand() / 2 + 4;
        })
    //x position is 3 pixels to the right of the bar
        .attr("x", function (d) {
            return x(d.value) + 3;
        })
        .text(function (d) {
            return d.value;
        });
}

function create_topic_terms_bar () {
    t_id = Number(document.getElementById("tid").innerHTML);
    document.getElementById("topic_id").innerHTML = "Topic id: " + t_id;
    document.getElementById("topicterms").innerHTML = "";

    var index = t_id - 1;
    var topicinds = tt_inds[index];
    var topicscores = tt_scores[index];
    var data = [];
    for (var i = 0; i < 15; i++) {
        var bar = {name:vocab[topicinds[i]-1], value:topicscores[i].toFixed(4)};
        data.push(bar);
    }

    //sort bars based on value
    data = data.sort(function (a, b) {
        return d3.ascending(a.value, b.value);
    })

    //set up svg using margin conventions - we'll need plenty of room on the left for labels
    var margin = {
        top: 15,
        right: 50,
        bottom: 15,
        left: 120
    };

    var width = window.innerWidth * .4 - margin.left - margin.right,
        height = 500 - margin.top - margin.bottom;

    var svg = d3.select("#topicterms").append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
        .append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    var x = d3.scale.linear()
        .range([0, width])
        .domain([0, d3.max(data, function (d) {
            return d.value;
        })]);

    var y = d3.scale.ordinal()
        .rangeRoundBands([height, 0], .1)
        .domain(data.map(function (d) {
            return d.name;
        }));

    //make y axis to show bar names
    var yAxis = d3.svg.axis()
        .scale(y)
    //no tick marks
        .tickSize(0)
        .orient("left");

    var gy = svg.append("g")
        .attr("class", "y axis")
        .call(yAxis)

    var bars = svg.selectAll(".bar")
        .data(data)
        .enter()
        .append("g")

    //append rects
    bars.append("rect")
        .attr("class", "bar")
        .attr("y", function (d) {
            return y(d.name);
        })
        .attr("height", y.rangeBand())
        .attr("x", 0)
        .attr("width", function (d) {
            return x(d.value);
        });

    //add a value label to the right of each bar
    bars.append("text")
        .attr("class", "label")
    //y position of the label is halfway down the bar
        .attr("y", function (d) {
            return y(d.name) + y.rangeBand() / 2 + 4;
        })
    //x position is 3 pixels to the right of the bar
        .attr("x", function (d) {
            return x(d.value) + 3;
        })
        .text(function (d) {
            return d.value;
        });
}

function create_css_doc_topics() {
    create_css_topic_terms();
    create_css_document();
}

function create_css_topic_terms () {
    // clear the output divs -- topicterms and doctopicsdiv
    document.getElementById("termstopic1").innerHTML = "";
    document.getElementById("termstopic2").innerHTML = "";
    document.getElementById("termstopic3").innerHTML = "";
    document.getElementById("termstopic4").innerHTML = "";
    document.getElementById("termstopic5").innerHTML = "";
    document.getElementById("cssdoctopics").innerHTML = "";

    // create hash array for five topics
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
    var ttermsdiv = document.getElementById("topicterms");
    docdata_inds = dt_inds[doc_index];
    docdata_scores = dt_scores[doc_index];

    // for each topic 1-5
    for (var i = 0; i < 5; i++) {
        var topic = docdata_inds[i];
        var score = Number(docdata_scores[i]).toFixed(4);

        // get top terms for that topic
        var tindex = topic - 1;
        var topicinds = tt_inds[tindex];
        var topicscores = tt_scores[tindex];
        var nterms = 50; //300 is max
        var tt = []
        for (var j = 0; j < nterms; j++) {
            var t = vocab[topicinds[j]-1]
            var s = Number(topicscores[j]).toFixed(4);
            topic_hash_arrays[i][t] = s;
            tt.push(t);
        } // for each term in the topic

        var text = tt.join(' ');
        var tdiv = document.getElementById("termstopic" + (i+1).toString());
        var tp = document.createElement("p");
	var tdivtitle = document.createElement("h3");
	tdivtitle.innerHTML = "topic id: " + topic;
	tdivtitle.style.color= "black";
	tdiv.appendChild(tdivtitle);
        tp.innerHTML = text;
        tp.style.color="black";
        tdiv.classList.add("topic" + (i+1).toString());
        tdiv.appendChild(tp);
    }//for each top 5 topics fill the hash and add terms to page
}// create css topic terms

function create_css_document() {
   // using document index get the text
   text = file_contents[doc_index];
   var words = text.replace(/\n/g," ").split(" ");
    for (var i = 0; i < Math.min(350, words.length); i++) {
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
            //console.log("here");
            wd.className = "topic" + (topt + 1).toString();
        }

        //append to the cssdoctopicsdiv div
        dtd = document.getElementById("cssdoctopics");
        dtd.appendChild(wd);
    }//for each word
    end = document.createElement("p")
    end.innerHTML = " ... ";
    end.style.textAlign="center";
    end.style.fontSize="xx-large";
    dtd.appendChild(end);
}//css_document
