const express = require('express')
const http = require('http')
const app = express()
const PORT = process.env.PORT || 8008
const server = http.createServer(app)
const cors = require('cors')
const client = require('./Helper/connections_redis')
const PlantRoute = require('./Routes/Plant.route')
const AdminRoute = require('./Routes/Admin.route')
require('./Helper/connections_mongoodb')
app.get('/', (req, res, next) => {
    res.send("Home page!!")
})
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({extended: true}));
app.use('/plant', PlantRoute);
app.use('/admin', AdminRoute);
server.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`)
})