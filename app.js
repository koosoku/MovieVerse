var express = require('express');
var app = express();
var path = require('path');


var movieList = [
	{id: 1, desc: 'Movie', imagePath:'./images/movie.jpg'},
	{id: 1, desc: 'Movie', imagePath:'./images/movie.jpg'},
	{id: 1, desc: 'Movie', imagePath:'./images/movie.jpg'},
	{id: 1, desc: 'Movie', imagePath:'./images/movie.jpg'},
	{id: 1, desc: 'Movie', imagePath:'./images/movie.jpg'},
	{id: 1, desc: 'Movie', imagePath:'./images/movie.jpg'},
	{id: 1, desc: 'Movie', imagePath:'./images/movie.jpg'},
	{id: 1, desc: 'Movie', imagePath:'./images/movie.jpg'}
];

app.get('/',(req, res) => {
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