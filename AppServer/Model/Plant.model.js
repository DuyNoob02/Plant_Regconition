const mongoose = require('mongoose');
const Schema = mongoose.Schema;
const {Connection} = require('../Helper/connections_mongoodb')

const PlantSchema = new Schema({
    name: {
        type: String,
        require: true,
    },
    scientificName: {
        type: String,
    },
    code: {
        type: String,
        require: true,
    },
    description: {
        type: String,
    },
    info: {
        type: String,
        require: true,
    },
    images: [{
        type: String,
    }],
})

module.exports = Connection.model('Plant', PlantSchema)
