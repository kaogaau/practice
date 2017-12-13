
/* Register from GoogleSheet Male */
//1bnAz3gJ9GT4WmgKobjCOIycZt93
$('#btn_SheetMale').on("click",function() {
  $('#btn_SheetMale').addClass('loading');
  var sheetURL = $('#input_SheetMale').val().trim()
  console.log(sheetURL)
  if(sheetURL == "111"){
    alert("請輸入");
  } else {
    var testURL = "12Yup8nvMr0lBeJ8B-VBixkE9EYA9Wpl3KvAuIAJ7Lss";
    var dataURL = "https://spreadsheets.google.com/feeds/list/" + '1YvVWzOq51mKKCtFVZqMNXjIyp3RamZdz756KvEU7lho' + "/od6/public/values?alt=json";

    var getData = $.get(dataURL,'').then(function (response) {
       return response.feed.entry;
    }).catch(function(error){
        return error;
    });

    getData.done(function(data){
      var jsonform = objtojson(data)
      //console.log(jsonform[0])
      //console.log(JSON.stringify(jsonform))
      //RegisterMale(jsonform)
      for (i = 0 ; i < jsonform.length ; i++ ) {
        RegisterMale(jsonform[i])
      }

    });
    $('#btn_SheetMale').removeClass('loading');


  };
});

$('#btn_SheetFemale').on("click",function() {
  $('#btn_SheetFemale').addClass('loading');
  var sheetURL = $('#input_SheetMale').val().trim()
  console.log(sheetURL)
  if(sheetURL == "111"){
    alert("請輸入");
  } else {
    var testURL = "12Yup8nvMr0lBeJ8B-VBixkE9EYA9Wpl3KvAuIAJ7Lss";
    var dataURL = "https://spreadsheets.google.com/feeds/list/" + '13gnZVzPdXly-nUU8q4p5hRt-V95BgSnncOBgt5BM_MM' + "/od6/public/values?alt=json";

    var getData = $.get(dataURL,'').then(function (response) {
       return response.feed.entry;
    }).catch(function(error){
        return error;
    });

    getData.done(function(data){
      var jsonform = objtojson(data)
      //console.log(jsonform[0])
      //console.log(JSON.stringify(jsonform))
      //RegisterMale(jsonform)
      for (i = 0 ; i < jsonform.length ; i++ ) {
        RegisterFeMale(jsonform[i])
      }

    });
    $('#btn_SheetFemale').removeClass('loading');


  };
});

/** Bulid GoogleSheet Data **/
function objtojson(data){
  var jsonData = [];
  for (var i = 0 ; i < data.length ; i ++){
    var pushData = {
      uid : data[i].gsx$no.$t,
      displayname : data[i].gsx$displayname.$t,
      birthday : data[i].gsx$birthday.$t,
      gender : data[i].gsx$gender.$t,
      area : data[i].gsx$area.$t,
      ntroduce : data[i].gsx$introduce.$t,
      chinese : data[i].gsx$chinese.$t,
      english : data[i].gsx$english.$t
    };
    jsonData.push(pushData)
  }
  //console.log(JSON.stringify(jsonData))
   return jsonData
};
/** Bulid GoogleSheet Data **/


function RegisterMale(data) {
  //window.location.host
  //default data
  var userNo = data.uid;
  var displayname = data.displayname;
  var birthday = randomDate(new Date((new Date().getFullYear() - parseInt(data.birthday)), 0, 1), new Date((new Date().getFullYear() - parseInt(data.birthday)), 12,1));
  var gender = data.gender;
  var geo = setlatlng(data.area);
  var ntroduce = data.ntroduce;


  var email = userNo + '@kayming.com';
  var password = 'kayming' + userNo;



  function createUser (email, password) {
      return new Promise(function (resolve, reject) {
          APPFirebase.auth().createUserWithEmailAndPassword(email,password).then(function (user) {
              var uid = user.uid;
              resolve(uid);
              console.log(uid);
          }).catch(function (error) {
              console.log(error.message);
              alert(error.message);
          });
      });
  };

  function uploadImg(uid) {
    return new Promise(function (resolve, reject) {
      var hostUrl = 'http://' + window.location.host + '/images/register/male/'+ userNo + '-' + 1 + '.jpg';
      toDataURL(hostUrl, function(data){
        var dataimage = data.replace(/^data:image\/(png|jpeg);base64,/, "")
        APPFirebase.storage().ref().child('images/avatars/' + uid ).putString(dataimage,'base64',{contentType:'image/PNG'}).then(function (data){
          //console.log(data);
          console.log('img uid: ' + uid)
          console.log('Uploaded a base64 string!');
          resolve(uid);
        }).catch(function(error){
          console.log(error)
        })
      });
    })
  };

  function getImgUrl(uid) {
      return new Promise(function (resolve, reject) {
          APPFirebase.storage().ref().child('images/avatars/' + uid ).getDownloadURL().then(function (url) {
              resolve({uid: uid, url: url});
          }).catch(function (error){
              alert(error.message);
          });
      });
  };

  function getMapInfo(data){
      var geocoder = new google.maps.Geocoder();
      //var geo = setlatlng();
      var latlng = geo;
      return new Promise(function(resolve, reject) {
          geocoder.geocode({ 'location': latlng }, function (results, status) { // called asynchronously
              if (status == google.maps.GeocoderStatus.OK) {
                  if(results[0]){
                      data.place_id = results[0].place_id;
                      data.lat = latlng.lat;
                      data.lng = latlng.lng;
                      resolve(data);
                  }
              } else {
                  reject(status);
              }
          });
      });
  };


  function setUserData(obj) {
      var sexOrientation = 'msf';
      var geocode = {
          lat:obj.lat,
          lng:obj.lng
      };

      var postData = {
          bio: ntroduce,
          birthday: birthday,
          chatStatus: 'Gaf',
          city: 'Taiwan',
          country: "",
          credit: 0,
          displayName: displayname,
          email: email,
          gender: "m",
          geocode: geocode,
          lang:{中文:true, 日文:false, 英文:true},
          locale: "",
          photoURL: obj.url,
          placeID: obj.place_id,
          sexOrientation: "msf",
          signupCompleted: true,
          termsAgreed: true,
          uid: obj.uid,
          vip: true
          //created:Math.round(+new Date()/1000),
          //lastUpdated:Math.round(+new Date()/1000),
      };

      console.log(postData)


      return new Promise(function(resolve, reject) {
          APPFirebase.database().ref('users/' + obj.uid).set(postData).then(function (user) {
              console.log('set IN !!!');
              resolve({userno: userNo, uid: obj.uid});
              //alert('Success!')
          }).catch(function (error) {
             //alert(error.message);
          });
      });
  };


  function uploadPhotos(uid) {
    return new Promise(function (resolve, reject){
      var photo_array = CheckImgExists(userNo);

    })
  }


  //createUser(email,password).then(uploadImg).then(getImgUrl).then(getMapInfo).then(setUserData);


  //MrCVml9ZmOUcqAhoxBwqxrKXuDI2
  var photo_array = CheckImgExists(userNo);
  var uid = 'MrCVml9ZmOUcqAhoxBwqxrKXuDI2';
  var base64Img = [];
  for (i = 0 ; i < photo_array.length ; i++ ) {
    console.log(photo_array[i])
    var name = generateFilename(uid)
    APPFirebase.storage().ref().child('userPhotos/' + uid + '/' + name + '.jpg' ).put(photo_array[i]).then(function (data){
      console.log(data.metadata.downloadURLs);
      //console.log(data.val());
    }).catch(function(error){
      console.log(error)
    })
  };


  //CheckImgExists(imgurl);
  /*
  toDataURL(photo_array[i], function(data){
    console.log(photo_array[i])
    var dataimage = data.replace(/^data:image\/(png|jpeg);base64,/, "")
    APPFirebase.storage().ref().child('userPhotos/' + uid + '/' + name + '.jpg' ).putString(dataimage,'base64',{contentType:'image/jpg'}).then(function (data){
      console.log(data.metadata.downloadURLs);
      //console.log(data.val());
    }).catch(function(error){
      console.log(error)
    })
  });
  */


};


function RegisterFeMale(data) {
  //window.location.host
  //default data
  var userNo = data.uid;
  var displayname = data.displayname;
  var birthday = randomDate(new Date((new Date().getFullYear() - parseInt(data.birthday)), 0, 1), new Date((new Date().getFullYear() - parseInt(data.birthday)), 12,1));
  var gender = data.gender;
  var geo = setlatlng(data.area);
  var ntroduce = data.ntroduce;


  var email = userNo + '@kayming.com';
  var password = 'kayming' + userNo;



  function createUser (email, password) {
      return new Promise(function (resolve, reject) {
          APPFirebase.auth().createUserWithEmailAndPassword(email,password).then(function (user) {
              var uid = user.uid;
              resolve(uid);
              console.log(uid);
          }).catch(function (error) {
              console.log(error.message);
              alert(error.message);
          });
      });
  };

  function uploadImg(uid) {
    return new Promise(function (resolve, reject) {
      var hostUrl = 'http://' + window.location.host + '/images/register/male/'+ userNo + '-' + 1 + '.jpg';
      toDataURL(hostUrl, function(data){
        var dataimage = data.replace(/^data:image\/(png|jpeg);base64,/, "")
        APPFirebase.storage().ref().child('images/avatars/' + uid ).putString(dataimage,'base64',{contentType:'image/PNG'}).then(function (data){
          //console.log(data);
          console.log('img uid: ' + uid)
          console.log('Uploaded a base64 string!');
          resolve(uid);
        }).catch(function(error){
          console.log(error)
        })
      });
    })
  };

  function getImgUrl(uid) {
      return new Promise(function (resolve, reject) {
          APPFirebase.storage().ref().child('images/avatars/' + uid ).getDownloadURL().then(function (url) {
              resolve({uid: uid, url: url});
          }).catch(function (error){
              alert(error.message);
          });
      });
  };

  function getMapInfo(data){
      var geocoder = new google.maps.Geocoder();
      //var geo = setlatlng();
      var latlng = geo;
      return new Promise(function(resolve, reject) {
          geocoder.geocode({ 'location': latlng }, function (results, status) { // called asynchronously
              if (status == google.maps.GeocoderStatus.OK) {
                  if(results[0]){
                      data.place_id = results[0].place_id;
                      data.lat = latlng.lat;
                      data.lng = latlng.lng;
                      resolve(data);
                  }
              } else {
                  reject(status);
              }
          });
      });
  };


  function setUserData(obj) {
      var sexOrientation = 'fsm';
      var geocode = {
          lat:obj.lat,
          lng:obj.lng
      };

      var postData = {
          bio: ntroduce,
          birthday: birthday,
          chatStatus: 'Gaf',
          city: 'Taiwan',
          country: "",
          credit: 0,
          displayName: displayname,
          email: email,
          gender: "f",
          geocode: geocode,
          lang:{中文:true, 日文:false, 英文:true},
          locale: "",
          photoURL: obj.url,
          placeID: obj.place_id,
          sexOrientation: "fsm",
          signupCompleted: true,
          termsAgreed: true,
          uid: obj.uid,
          vip: true
          //created:Math.round(+new Date()/1000),
          //lastUpdated:Math.round(+new Date()/1000),
      };

      console.log(postData)


      return new Promise(function(resolve, reject) {
          APPFirebase.database().ref('users/' + obj.uid).set(postData).then(function (user) {
              console.log('set IN !!!');
              resolve({userno: userNo, uid: obj.uid});
              //alert('Success!')
          }).catch(function (error) {
             //alert(error.message);
          });
      });
  };


  function uploadPhotos(uid) {
    return new Promise(function (resolve, reject){
      var photo_array = CheckImgExists(userNo);

    })
  }


  //createUser(email,password).then(uploadImg).then(getImgUrl).then(getMapInfo).then(setUserData);


  //MrCVml9ZmOUcqAhoxBwqxrKXuDI2
  var photo_array = CheckImgExists(userNo);
  var uid = 'MrCVml9ZmOUcqAhoxBwqxrKXuDI2';
  var base64Img = [];
  for (i = 0 ; i < photo_array.length ; i++ ) {
    console.log(photo_array[i])
    var name = generateFilename(uid)
    APPFirebase.storage().ref().child('userPhotos/' + uid + '/' + name + '.jpg' ).put(photo_array[i]).then(function (data){
      console.log(data.metadata.downloadURLs);
      //console.log(data.val());
    }).catch(function(error){
      console.log(error)
    })
  };


  //CheckImgExists(imgurl);
  /*
  toDataURL(photo_array[i], function(data){
    console.log(photo_array[i])
    var dataimage = data.replace(/^data:image\/(png|jpeg);base64,/, "")
    APPFirebase.storage().ref().child('userPhotos/' + uid + '/' + name + '.jpg' ).putString(dataimage,'base64',{contentType:'image/jpg'}).then(function (data){
      console.log(data.metadata.downloadURLs);
      //console.log(data.val());
    }).catch(function(error){
      console.log(error)
    })
  });
  */


};



function getBase64FromImageUrl(url) {
    var img = new Image();

    img.setAttribute('crossOrigin', 'anonymous');

    img.onload = function () {
        var canvas = document.createElement("canvas");
        canvas.width =this.width;
        canvas.height =this.height;

        var ctx = canvas.getContext("2d");
        ctx.drawImage(this, 0, 0);

        var dataURL = canvas.toDataURL("image/png");

        var url= dataURL.replace(/^data:image\/(png|jpg);base64,/, "");
        return dataURL
    };

    img.src = url;

}

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

function CheckImgExists(userNo) {
  var photo_array = [];
  for (i = 2 ; i < 5; i++ ) {
    var imgurl = 'http://' + window.location.host + '/images/register/male/'+ userNo + '-' + i + '.jpg';
    $.ajax({
      url: imgurl,
      async: false,
      success:function(res){
        //console.log(res)
        photo_array.push(imgurl)
      },
      error:function(res){
        //console.log(res)
      }
    });
  };
  return photo_array;
};

function generateFilename(uid) {
  return APPFirebase.database().ref('users/' + uid + '/photos').push().key;
};

function setlatlng(area) {

    var areaLatlng = {
        taipei:[
            {lat:25.0447193, lng:121.5190338},
            {lat:25.0407792, lng:121.5473505},
            {lat:25.0332211, lng:121.5588158},
            {lat:25.0403505, lng:121.5086404},
            {lat:25.0330169, lng:121.5500891},
            {lat:25.0569115, lng:121.5280869}
        ],
        xinbei:[
            {lat:25.0684452, lng:121.4916933},
            {lat:25.0864373, lng:121.4685883},
            {lat:25.0591448, lng:121.4846328},
            {lat:25.0138279, lng:121.455445},
            {lat:25.0145144, lng:121.459007},
            {lat:25.0077392, lng:121.4616349}
        ],
        taoyuan:[
            {lat:24.9900755, lng:121.3096995},
            {lat:25.015105, lng:121.299015},
            {lat:25.011638, lng:121.298480},
            {lat:24.954853, lng:121.216364},
            {lat:24.962795, lng:121.222917},
            {lat:24.955635, lng:121.214211}
        ],
        taichung:[
            {lat:24.153613, lng:120.652860},
            {lat:24.150912, lng:120.662261},
            {lat:24.139631, lng:120.660181},
            {lat:24.153534, lng:120.685638},
            {lat:24.138802, lng:120.682340},
            {lat:24.163798, lng:120.656148}
        ],
        tainan:[
            {lat:23.018173, lng:120.258334},
            {lat:23.018014, lng:120.226501},
            {lat:22.996097, lng:120.213476},
            {lat:22.994987, lng:120.207929},
            {lat:22.995603, lng:120.218121},
            {lat:22.989199, lng:120.197484}
        ],
        kaohsiung:[
            {lat:22.635771, lng:120.297165},
            {lat:22.654403, lng:120.288188},
            {lat:22.681303, lng:120.282843},
            {lat:22.614385, lng:120.300308},
            {lat:22.614499, lng:120.306224},
            {lat:22.623788, lng:120.302858}
        ]
    }

    var latlng
    var n = Math.floor(Math.random() * 6);

    switch(area){
        case "台北": //台北
            latlng = {lat:areaLatlng.taipei[n].lat, lng:areaLatlng.taipei[n].lng};
            break;
        case "新北": //新北
            latlng = {lat:areaLatlng.xinbei[n].lat, lng:areaLatlng.xinbei[n].lng};
            break;
        case "桃園": //桃園
            latlng = {lat:areaLatlng.taoyuan[n].lat, lng:areaLatlng.taoyuan[n].lng};
            break;
        case "台中": //台中
            latlng = {lat:areaLatlng.taichung[n].lat, lng:areaLatlng.taichung[n].lng};
            break;
        case "台南": //台南
            latlng = {lat:areaLatlng.tainan[n].lat, lng:areaLatlng.tainan[n].lng};
            break;
        case "高雄": //高雄
            latlng = {lat:areaLatlng.kaohsiung[n].lat, lng:areaLatlng.kaohsiung[n].lng};
            break;
    }

    return latlng;
};


function switchArea(data){
    var area;
    switch(parseInt(data)){
        case 1: //台北
            area = "台北";
            break;
        case 2: //新北
            area = "新北";
            break;
        case 3: //桃園
            area = "桃園";
            break;
        case 4: //台中
            area = "台中";
            break;
        case 5: //台南
            area = "台南";
            break;
        case 6: //高雄
            area = "高雄";
            break;
    };
    return area;
};

function randomDate(start, end) {
    //console.log(start.getTime());

    var d = new Date(start.getTime() + Math.random() * (end.getTime() -start.getTime())),
        //var d = new Date(start.getTime() + Math.random()),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();

    if (month.length < 2) month = '0' + month;
    if (day.length < 2) day = '0' + day;

    return [year, month, day].join('-');

    //var n = randomDate(new Date(2010, 0, 1), new Date(2010, 12,1))
};
