const express = require('express');
const request = require('request');
const app = express();
const path = require('path');
const pg = require('pg');
const baseURL ="https://image.tmdb.org/t/p/";
const posterSize = [
	"w92", "w154","w185","w342","w500","w780","original"
];

var movieList=[];


function fetchMovieByID(ID, callback) {
	console.log(ID)
	var client = new pg.Client(require('./config/database.json'));
	var results=[];
	client.connect( function(err) {
		if(err) {
			console.log(err);
		}
		var query = client.query("SELECT * FROM movie WHERE movieid = $1 ;",[ID.toString()]);
		query.on('row',function(row){
			results.push(row);
		});
		query.on('end', function() {
			callback(results);
		});
	});
}

function search(query){
	request('https://api.themoviedb.org/3/search/keyword?api_key=8a439f408d3ed4c974abe73cc1645699&query='+query,function(err,res,body){
		movieList=[];
		if (!err && res.statusCode == 200) {
			var jsonObj = JSON.parse(body);
			for (var i = 0; i<jsonObj.results.length; i++) {
			    console.log(jsonObj.results[i].id);
			    fetchMovieByID(jsonObj.results[i].id, function(result) {
			    	movieList.push(result);
			    });
			}
		console.log(jsonObj);
		}else{
			console.log(err);
			console.log(body);
		}

	});

}
function fetchAllMovies(callback){
	var client = new pg.Client(require('./config/database.json'));
	client.connect( function(err) {
		if(err) {
			console.log(err);
		}
		var query = client.query("SELECT * FROM movie" , function(err,res){
			if (err)
				return
			else{
				for (var i =0 ; i< res.rows.length; i++){
					var result = res.rows[i];
					movieList.push({id: result.movieid, title: result.name , imagePath: baseURL + posterSize[5]+ result.poster_image_path})
				}
			}

		});
		query.on('end', function() {
			callback();
		});


	});
}

app.get('/',function(req, res){
	fetchAllMovies(function(){
		res.render('index', {
			title: 'MovieVerse',
			movies: movieList
		});
	});
});
app.get('/movie/:movieID',function(req,res){
	fetchMovieByID(req.params.movieID, function(results){
		console.log(results);
		res.render('details',{
			title:results[0]['name'],
			description:results[0]['description'],
			backDropPath:baseURL + posterSize[5]+results[0]['backdrop_image_path']
		})
	})
})

//configuration
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname,'views'));
app.use(express.static(__dirname));

//server port
app.listen(1337, function(){
	console.log('ready on port 1337');
} );
