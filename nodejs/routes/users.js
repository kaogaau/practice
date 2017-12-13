var express = require('express');
var fs = require('fs');
var XMLHttpRequest = require("xmlhttprequest").XMLHttpRequest;
var router = express.Router();
var moment = require('moment');
var sharp = require('sharp');
var firebase = require('../config/firebaseCMS');
var appFirebase = require('../config/firebaseAPP');
var ref = firebase.database().ref("users");
var gcloud = require('gcloud');
var keyFilename = "MeeQ-c2b73f059432.json";

console.log(keyFilename)

var gcs = gcloud.storage({
  projectId: 'kjyl-150415',
  keyFilename: keyFilename
});
var bucket = gcs.bucket('kjyl-150415.appspot.com');

module.exports = function(app){
    app.get('/api/getbaconcmsusers', function(req, res, next) {
      var user = firebase.auth().currentUser;
          if (user) {
            var data = {
              "data":[]
            };
            ref.once("value").then(function(users){
              var usersObj = users.val()
              Object.keys(usersObj).forEach(function(key, index){
                var insertData = {
                  name: usersObj[Object.keys(usersObj)[index]].displayname,
                  email: usersObj[Object.keys(usersObj)[index]].email,
                  crd_dt: moment.unix(usersObj[Object.keys(usersObj)[index]].crd_dt).format("YYYY/MM/DD"),
                  uid: usersObj[Object.keys(usersObj)[index]].uid
                };
                data.data.push(insertData)
              });
              res.json(data);
            }).catch(function(error) {
              //console.log(error.message)
              res.send(500, error.message)
            });
          } else {
              res.render('login');
          }
    });

    app.get('/api/getBaconUsers', function(req, res, next){
      var user = firebase.auth().currentUser;
      if (user) {
        var data = {
          "data":[]
        }
        appFirebase.database().ref("users").once("value").then(function(users){
          var usersObj = users.val()
          Object.keys(usersObj).forEach(function(key, index){
            var insertData = {
              uid: usersObj[Object.keys(usersObj)[index]].uid,
              displayname: usersObj[Object.keys(usersObj)[index]].displayName,
              email: usersObj[Object.keys(usersObj)[index]].email,
              gender: usersObj[Object.keys(usersObj)[index]].gender,
              birthday: usersObj[Object.keys(usersObj)[index]].birthday,
              city: usersObj[Object.keys(usersObj)[index]].city,
              photourl: usersObj[Object.keys(usersObj)[index]].photoURL,
              vip: usersObj[Object.keys(usersObj)[index]].vip
            };
            data.data.push(insertData)
          });
          res.json(data);
        }).catch(function(error) {
          //console.log(error.message)
          res.send(500, error.message)
        });
      } else {
        //res.render('login');
        res.redirect('/')
      }

    })


    app.post('/api/addbaconcmsusers', function(req, res, next) {
      var user = firebase.auth().currentUser;
          if (user) {
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
                res.send(500, error.message);
            });
          } else {
              res.render('login');
          }
    });

    app.post('/api/addbaconusersmale', function(req, res, next){
      //console.log(req.body);
      //res.json(req.body)
      var arr_json = req.body;
      console.log(arr_json.length)
      res.json(arr_json)

      for (i = 0 ; i < arr_json.length ; i++) {
        BaconUserRegister(arr_json[i]);
      };

      var defalut = firebase.storage().ref();


    });

    app.post('/api/addarticle', function(req, res, next){
      var user = firebase.auth().currentUser;
          if (user) {
            var uid = user.uid;
            var title = req.body.title;
            var data = req.body.data;
            var pushKey = getkey()
            console.log('uid: ' + uid + ' data: ' + data + ' title: ' + title);
            appFirebase.database().ref('/article/' + pushKey).set({uid: uid, title: title, data: data}, function(error) {
              if (error) {
                res.send(500, error.message);
              } else {
                console.log('good')
                res.send("Data saved successfully.");
              }
            });

          } else {

          }


    });

};

function getkey() {
  return appFirebase.database().ref('/article').push().key;
};

function BaconUserRegister(data){
  var uid = data.uid;
  var displayname = data.displayname;
  var birthday = data.birthday;
  var gender = data.gender;
  var area = data.area;
  var introduce = data.introduce;
  var chinese = data.chinese;
  var english = data.english;
  var email = uid + '@kayming.com';
  var password = 'kayming' + uid ;
  console.log(email + '   ' + password)

  /*
  firebase.database().ref('users/').orderByChild('email').equalTo(email).on("value", function (data) {
        if(data.val() == null){
            function createUser (email, password) {
                return new Promise(function (resolve, reject) {
                    firebase.auth().createUserWithEmailAndPassword(email,password).then(function (user) {
                        var uid = user.uid;
                        resolve(uid);
                    }).catch(function (error) {
                        console.log(error.message);
                        alert(error.message);
                    });
                });
            };

            function uploadImg(uid) {
                return new Promise(function (resolve, reject) {
                    dataurl(imgPath, function(dataUrl) {
                        firebase.storage().ref().child('avatars/' + uid + '.jpg').put(dataUrl).then(function (data) {
                        resolve(uid);
                        //return [{uid: data, imgurl: }]
                        }).catch(function (error) {
                            alert(error.message);
                        });
                    });
                });
            };

            function getImgUrl(uid) {
                return new Promise(function (resolve, reject) {
                    firebase.storage().ref().child('avatars/' + uid + '.jpg').getDownloadURL().then(function (url) {
                        resolve({uid: uid, url: url});
                    }).catch(function (error){
                        alert(error.message);
                    });
                });
            };

            //createUser(email,password).then(uploadImg).then(getImgUrl).then(getMapInfo).then(setUserData).then(postGoogleSheet);
            createUser(email,password).then(uploadImg).then(getImgUrl)
        }
    });
    */

    bucket.upload('./public/images/register/male/' + uid + '-1.jpeg', function(err, file) {
      console.log(err);
      console.log(file)
    });

    fs.readFile('./public/images/register/male/' + uid + '-1.jpeg' , function(err, buffer) {
      //console.log(new Buffer(buffer).toString('base64'));
    })
    //var defalut = Firebase.database();
    sharp('./public/images/register/male/' + uid + '-1.jpeg')
      .rotate()
      .resize(200)
      .toBuffer()
      .then(function(data){
        //console.log(new Buffer(buffer).toString('base64'))
        var updataURL = new Buffer(data).toString('base64');

        //console.log('RESULT:', new Buffer(data).toString('base64'))
        //appFirebase.storage().ref('images/avatars/4444').putString(updataURL, 'base64', {contentType:'image/jpg'})
      })
      .catch(function(err){console.log(err)})




};

function toDataURL(url, callback) {
  var xhr = new XMLHttpRequest();
  xhr.onload = function() {
    var reader = new FileReader();
    reader.onloadend = function() {
      callback(reader.result);
    }
    reader.readAsDataURL(xhr.response);
  };
  xhr.open('GET', url);
  xhr.responseType = 'blob';
  xhr.send();
}
