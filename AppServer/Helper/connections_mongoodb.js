const mongoose = require('mongoose')
require('dotenv').config()

function newConnection(uri){
    const conn = mongoose.createConnection(uri, {
        useNewUrlParser: true,
        useUnifiedTopology: true
    })

    
    conn.on('connected', function() {
        console.log(`Mongodb:::::connected:::::${this.name}`);
    })

    conn.on('disconnected', function(){
        console.log(`Mongodb:::::disconneted:::::${this.name}`);
    })

    
    conn.on('error', function(error){
        console.log(`Mongodb:::error:::${JSON.stringify(error)}`);
    })

    
    conn.on('SIGINT', async()=>{
        console.log('Closing MongoDB connection....');
        await conn.close();
        console.log('MongoDB connection closed');
        process.exit(0);
    })

    return conn;
}

const Connection = newConnection(process.env.URI_MONGODB_PROJECT);

module.exports = { Connection }