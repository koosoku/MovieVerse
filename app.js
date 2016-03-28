var express = require('express');
var app = express();
var path = require('path');
// var bodyParser = require('body-parser');

var request = require('request');

var baseURL ="https://image.tmdb.org/t/p/";
var posterSize = [
	"w92", "w154","w185","w342","w500","w780","original"
];

// app.use(bodyParser());


var movieList = [
	{id: 1, desc: 'Movie', imagePath:'./images/movie.jpg'},
	{id: 1, desc: 'Movie', imagePath:'./images/movie.jpg'},
	{id: 1, desc: 'Movie', imagePath:'./images/movie.jpg'},
	{id: 1, desc: 'Movie', imagePath:'./images/movie.jpg'},
	{id: 1, desc: 'Movie', imagePath:'./images/movie.jpg'},
	{id: 1, desc: 'Movie', imagePath:'./images/movie.jpg'},
	{id: 1, desc: 'Movie', imagePath:'./images/movie.jpg'}
];

app.get('/',(req, res) => {
		request('https://api.themoviedb.org/3/movie/550?api_key=8a439f408d3ed4c974abe73cc1645699', function (err, res, body) {
	  if (!err && res.statusCode == 200) {
	  	var obj = JSON.parse(body);
	    console.log(baseURL + posterSize[5]+ obj.poster_path);
	    movieList.push({id: 1, desc: obj.original_title, imagePath: baseURL + posterSize[5]+ obj.poster_path});
	  }
	});
	res.render('index', {
		title: 'MovieVerse',
		movies: movieList
	});
});

//configuration
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname,'views'));
app.use(express.static(__dirname));

//server port
app.listen(1337, () =>{
	console.log('ready on port 1337');
} );