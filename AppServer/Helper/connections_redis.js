const redis = require('redis');

const client = redis.createClient({
    port: 6379,
    host: "redis://red-co17rbcf7o1s73ca01u0"
})
// const client = redis.createClient({
//     port: 6379,
//     host: "127.0.0.1"
// })

client.ping((err, pong)=>{
    console.log(pong);
})

client.on('error', function(error){
    console.log(error);
})

client.on('connect', function(error){
    console.log("connected");
})

client.on('ready', function(error){
    console.log("ready");
})

module.exports = client