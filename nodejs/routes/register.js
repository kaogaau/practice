var express = require('express');
var moment = require('moment');
var router = express.Router();
//var userDervice = require('./user_service');
var firebase = require('../config/firebaseCMS');
var appFirebase = require('../config/firebaseAPP');


module.exports = (app) => {
    /**
    註冊API
     Post {
        email(string),
        password(string),
        displayname(string)
     }
    **/
    app.post("/api/register", function(req, res){
        firebase.auth().createUserWithEmailAndPassword(req.body.email, req.body.password).then(function(user) {
            console.log('---user---')
            console.log(user);
            var resMsg = {
              code: 'success',
              data: user
            };
            //res.send(resMsg);
            firebase.database().ref('users/' + user.uid).set({
                uid: user.uid,
                email: user.email,
                displayname: req.body.displayname,
                authority: {
                    admin:true
                },
                crd_dt: moment().unix()
            });
            res.send(resMsg);
        }, function(error) {
            var resMsg = {
                code: 'error',
                data: error.message
            };
            res.send(resMsg);
        });
    });

};
