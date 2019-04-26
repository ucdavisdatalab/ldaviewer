function create_charts() {
  document.getElementById("doctopics").innerHTML = "";
  document.getElementById("topicterms").innerHTML = "";
  create_doc_topics();
  create_topic_terms();
  return;
}

function create_doc_topics () {
  //doc_id = document.getElementById("document").value;
  doc_title = document.getElementById("document").value;
  doc_id = filenames[doc_title];
  console.log(doc_id);
  if (doc_id == undefined)  {
    alert("doc: " + doc_title + " not found");
  }

  document.getElementById("docid_title").innerHTML = "Document tile: " + doc_title;
  console.log(doc_id);
  document.getElementById("doctopics").innerHTML = "";

  for (var i =0; i < doctopics.length; i++){
    if (doctopics[i]["name"] == doc_id)
      index = i;
  }
  var docdata = doctopics[index];
  var data = [];
  for (var i = 0; i < docdata["scores"].length; i++) {
    var bar = {name:"Topic " + docdata["topics"][i], value:Number(docdata["scores"][i]).toFixed(4)};
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
    left: 60
  };

  var width = window.innerWidth * .3 - margin.left - margin.right,
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
      create_topic_terms();
      console.log("clicked " + elem[1]);
      document.getElementById("lda-topic").value=elem[1] - 1;
      document.getElementById("lda-topic-up").click();
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

function create_topic_terms () {
  t_id = Number(document.getElementById("tid").innerHTML);
  document.getElementById("topic_id").innerHTML = "Topic id: " + t_id;
  document.getElementById("topicterms").innerHTML = "";

  var index = t_id - 1;
  var topicdata = topicterms[index];
  console.log(index);
  var data = [];
  for (var i = 0; i < 15; i++) {
    var bar = {name:topicdata["terms"][i], value:topicdata["scores"][i].toFixed(4)};
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
    left: 90
  };

  var width = window.innerWidth * .3 - margin.left - margin.right,
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


