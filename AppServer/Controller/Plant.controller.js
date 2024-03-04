const createError = require('http-errors')
const Plant = require('../Model/Plant.model')
// const fs = require('fs');

module.exports = {
    getPlant: async (req, res, next) => {
        try {
            const result = await Plant.find({
            })
            if (!result) {
                throw createError.NotFound()
            }
            return res.json({ result })
        } catch (error) {
            next(error)
        }
    },

    createPLantInfo: async (req, res, next) => {
        try {
            const { name, scientificName, code, description, info } = req.body;
            //xu ly loi khong co file duoc chon
            if (!req.files) {
                throw createError.BadRequest('No file uploaded');
            }
            const isExist = await Plant.findOne({
                code
            })
            if (isExist) {
                throw createError.Conflict(`${code} is ready been created!`)
                // res.status(409).json({
                //     message: 'conflict'
                // })
            }
            const newPlant = new Plant({
                name: name,
                scientificName: scientificName,
                code: code,
                description: description,
                info: info,
                images: req.files.map(file => file.path),
            });
            const saved = await newPlant.save();
            return res.status(200).json({
                saved
            });
        } catch (error) {
            next(error)
        }
    },

    getPlantInfo: async (req, res, next) => {
    try {
        const { code } = req.query;
        console.log(code);
        const result = await Plant.find({ code: code });
        console.log(result);
        if (result.length === 0) {
            throw createError.NotFound('Can not find plant info');
        }
        return res.status(200).json({
            result
        });
    } catch (error) {
        next(error);
    }
}

}