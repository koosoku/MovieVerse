var express = require('express');
var app = express();
var path = require('path');


var movieList = [
	{desc: 'Movie 1'},
	{desc: 'Movie 1'},
	{desc: 'Movie 1'},
	{desc: 'Movie 1'},
	{desc: 'Movie 1'},
	{desc: 'Movie 1'},
	{desc: 'Movie 1'},
	{desc: 'Movie 1'},
	{desc: 'Movie 1'},
	{desc: 'Movie 1'},
	{desc: 'Movie 1'},
	{desc: 'Movie 1'}
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
app.use(express.static(path.join(__dirname,'bower_components')));

//server port
app.listen(1337, () =>{
	console.log('ready on port 1337');
} );