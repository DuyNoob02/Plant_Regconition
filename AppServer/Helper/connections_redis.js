const redis = require('redis');

// const client = redis.createClient({
//     port: 6379,
//     host: "rediss://red-co17rbcf7o1s73ca01u0:pEgdv6Y5VeMqkpK9YfAKyZU9m0SjhfO0@singapore-redis.render.com"
// })
// rediss://red-co17rbcf7o1s73ca01u0:pEgdv6Y5VeMqkpK9YfAKyZU9m0SjhfO0@singapore-redis.render.com:6379
const client = redis.createClient({
    port: 6379,
    host: "127.0.0.1"
})

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