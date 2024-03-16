const express = require('express')
const route = express.Router()
const AdminController = require('../Controller/Admin.controller')

route.post('/register', AdminController.register)
route.post('/login', AdminController.login)
route.post('/logout', AdminController.logout)

module.exports = route