var express = require('express');
var router = express.Router();
var firebase = require('../config/firebaseCMS');
var appFirebase = require('../config/firebaseAPP');

/* GET home page. */

module.exports = function(app){
    app.get('/', function(req, res, next) {
      var user = firebase.auth().currentUser;
      console.log('get: ' + user)
          if (user) {
            console.log('user login')
              res.render('index');
          } else {
              res.render('login');
          }
    });

    app.post('/login', function(req, res, next){
      const email = req.body.email;
      const password = req.body.password;
      firebase.auth()
       .signInWithEmailAndPassword(email, password)
       .then(function(user) {
         //res.send(user);
         res.json(user);
       })
       .catch(function(error) {
         //console.log(error.message)
         res.send(500, error.message);
       });
    });

    app.get('/logout', function(req, res){
      firebase.auth().signOut().then(function(){
        res.redirect('/')
      })

    })

    app.get('/baconcms', function(req, res, next) {
      var user = firebase.auth().currentUser;
      if(user){
        res.render('baconcms.ejs');
      }else{
        //res.render('login');
        res.redirect('/')
      }
      //res.render('baconcms.ejs')
    });

    app.get('/baconusers', function(req, res, next) {
      var user = firebase.auth().currentUser;
      if(user){
        res.render('baconusers.ejs');
      }else{
        //res.render('login');
        res.redirect('/')
      }
      //res.render('baconusers.ejs')
    });

    app.get('/article', function(req, res, next) {
      var user = firebase.auth().currentUser;
      if(user){
        res.render('article.ejs');
      }else{
        //res.render('login');
        res.redirect('/')
      }
      //res.render('baconusers.ejs')
    });

    app.get('/editorarticle', function(req, res, next) {
      var user = firebase.auth().currentUser;
      if(user){
        res.render('editorArticle.ejs');
      }else{
        //res.render('login');
        res.redirect('/')
      }
      //res.render('baconusers.ejs')
    });
}
