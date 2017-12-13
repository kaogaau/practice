var firebase = require('firebase');
var APPFirebaseConfig = {
  apiKey: "AIzaSyBYTZDmeWcR9MEdiUTdgZGb80nDWYLnCSk",
  authDomain: "kjyl-150415.firebaseapp.com",
  databaseURL: "https://kjyl-150415.firebaseio.com",
  projectId: "kjyl-150415",
  storageBucket: "kjyl-150415.appspot.com",
  messagingSenderId: "725652377518"
};
var APPFirebase = firebase.initializeApp(APPFirebaseConfig, "APP");

module.exports = APPFirebase
