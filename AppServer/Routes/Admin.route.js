const express = require('express')
const route = express.Router()
const AdminController = require('../Controller/Admin.controller')
const uploadCloud = require('../Helper/Plant_cloudinary')

route.post('/register', AdminController.register)
route.post('/login', AdminController.login)
route.post('/logout', AdminController.logout)


route.get('/getPlant', AdminController.getPlant);
route.get('/getPLant/:id', AdminController.getPlantByID);
route.post('/createPlant',uploadCloud.array('images'), AdminController.createPLantInfo);
route.post('/updatePlant/:id', uploadCloud.array('images'), AdminController.editPlantInfo)
module.exports = route