var firebase = require('firebase');
var CMSFirebaseConfig = {
    apiKey: "AIzaSyC5vrjT-1yrlIVz5drhoQUcuf7ugiSc6sE",
    authDomain: "meeq-cms.firebaseapp.com",
    databaseURL: "https://meeq-cms.firebaseio.com",
    projectId: "meeq-cms",
    storageBucket: "meeq-cms.appspot.com",
    messagingSenderId: "933202199911"
};
var CMSFirebase = firebase.initializeApp(CMSFirebaseConfig);

module.exports = CMSFirebase
