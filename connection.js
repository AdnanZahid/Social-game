var http    = require('http');
var path    = require('path');
var express = require('express');
var app     = express();
var io      = require('socket.io');
var port    = process.env.PORT || 80;

app.use(express.static(path.join(__dirname, "")));

var server = http.createServer(app).listen(port);
io = io.listen(server);

var socketObjects = io.sockets.sockets;

var clientID = 0;

var gameOvers = [];

io.sockets.on("connect", function(socket) {

    console.log("Player connected!");

    socket.emit("assignID", clientID);

    gameOvers[clientID] = false;
    
    socket.broadcast.emit("spawn", clientID);
    
    socket.broadcast.emit("requestID");

    socket.on("requestID", function(ID) {

        if (!gameOvers[ID[0]]) {

            console.log("requestID" + ": " + ID[0]);

            var lastObject = socketObjects[socketObjects.length - 1];

            lastObject.emit("spawn", ID[0]);
        }
    });

    var events = ["position", "rotation", "fire"];
    
    events.forEach(function(anEvent) {

        socket.on(anEvent, function(value) {

            console.log(anEvent + ": " + value);

            io.sockets.emit(anEvent, value);
        });
    });

    socket.on("gameOver", function(value) {

        console.log("gameOver" + ": " + value);

        io.sockets.emit("gameOver", value);

        gameOvers[clientID] = true;
    });

    clientID ++;
});