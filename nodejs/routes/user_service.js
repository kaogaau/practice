/*
var firebase = require('firebase');
var FirebaseConfig = {
apiKey: "AIzaSyC5vrjT-1yrlIVz5drhoQUcuf7ugiSc6sE",
authDomain: "meeq-cms.firebaseapp.com",
databaseURL: "https://meeq-cms.firebaseio.com",
projectId: "meeq-cms",
storageBucket: "meeq-cms.appspot.com",
messagingSenderId: "933202199911"
};
firebase.initializeApp(FirebaseConfig);

addUser2 = async (email, password) => {
    console.log('add email: ' + email);
    console.log('add passowrd: ' + password)
    await firebase.auth().createUserWithEmailAndPassword(email, password).then((req) => {
        return req
    }).catch((error) => {
        return error
    })
};


function addUser(email,password){
    return new Promise(function(resolve, reject){
        firebase.auth().createUserWithEmailAndPassword(email, password).then(function (user){
            resolve(user)
        }).catch(function (error) {
            reject(error)
        })
    });
};

function compUser(email, password){
    addUser(email,password)
}


module.exports = {
    addUser: compUser
}
    */