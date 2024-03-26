const express = require('express')
const route = express.Router()
// const Plant = require('../Model/Plant.model')
const PlantController = require('../Controller/Plant.controller')


route.get('/getPlantInfor/query', PlantController.getPlantInfo);
route.get('/search/query', PlantController.search)

module.exports = route
