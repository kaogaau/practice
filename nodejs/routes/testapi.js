/**
 * Created by frank on 2017/6/5.
 */
var express = require('express');
var moment = require('moment');
var router = express.Router();

module.exports = function (app, firebase) {
    app.get("/testapi", function(req, res){
        for(i=0;i<10;i++){
          res.json(i);
        }
    })
}
