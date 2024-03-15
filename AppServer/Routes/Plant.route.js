const express = require('express')
const route = express.Router()
// const Plant = require('../Model/Plant.model')
const PlantController = require('../Controller/Plant.controller')
const uploadCloud = require('../Helper/Plant_cloudinary')

route.get('/', PlantController.getPlant);
route.get('/getPlantInfor/query', PlantController.getPlantInfo);
route.post('/',uploadCloud.array('images'), PlantController.createPLantInfo);
route.get('/search/query', PlantController.search)

module.exports = route
