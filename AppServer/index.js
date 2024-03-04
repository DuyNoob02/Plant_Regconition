const express = require('express')
const http = require('http')
const app = express()
const PORT = process.env.PORT || 8008
const server = http.createServer(app)
const PlantRoute = require('./Routes/Plant.route')
require('./Helper/connections_mongoodb')
app.get('/', (req, res, next) => {
    res.send("Home page!!")
})

app.use(express.json());
app.use(express.urlencoded({extended: true}));
app.use('/plant', PlantRoute);

server.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`)
})