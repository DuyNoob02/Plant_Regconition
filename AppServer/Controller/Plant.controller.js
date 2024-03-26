const createError = require('http-errors')
const Plant = require('../Model/Plant.model')
// const fs = require('fs');

module.exports = {
    // getPlant: async (req, res, next) => {
    //     const pageQuery = req.query.page || 1;
    //     const count = 10;
    //     try {

    //         const result = await Plant.find({
    //         })
    //             .skip((pageQuery - 1) * count)
    //             .limit(count)

    //         const totalItem = (await Plant.find({})).length
    //         // console.log(totalItem);
    //         const totalPage = Math.ceil(totalItem / count);
    //         if (!result) {
    //             throw createError.NotFound()
    //         }
    //         return res.json({ result, totalPage })
    //     } catch (error) {
    //         next(error)
    //     }
    // },

    // getPlantByID: async (req, res, next) => {
    //     const { id } = req.params;
    //     // const  id  = req.params;
    //     console.log(id);
    //     try {
    //         const result = await Plant.findById(id)
    //         // console.log(result);
    //         if (!result) {
    //             throw createError.NotFound();
    //         }
    //         return res.status(200).json({ result })
    //     } catch (error) {
    //         next(error)
    //     }
    // },

    // createPLantInfo: async (req, res, next) => {
    //     try {
    //         const { name, scientificName, code, description, info } = req.body;
    //         //xu ly loi khong co file duoc chon
    //         if (!req.files) {
    //             throw createError.BadRequest('No file uploaded');
    //         }
    //         const isExist = await Plant.findOne({
    //             code
    //         })
    //         if (isExist) {
    //             throw createError.Conflict(`${code} is ready been created!`)
    //             // res.status(409).json({
    //             //     message: 'conflict'
    //             // })
    //         }
    //         const newPlant = new Plant({
    //             name: name,
    //             scientificName: scientificName,
    //             code: code,
    //             description: description,
    //             info: info,
    //             images: req.files.map(file => file.path),
    //         });
    //         const saved = await newPlant.save();
    //         return res.status(200).json({
    //             saved
    //         });
    //     } catch (error) {
    //         next(error)
    //     }
    // },

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
    },
    search: async (req, res, next) => {
        try {
            const { query } = req.query;
            console.log(query);
            const result = await Plant.find({
                $or: [
                    { name: { $regex: new RegExp(query, 'i') } },
                    { scientificName: { $regex: new RegExp(query, 'i') } },
                    { description: { $regex: new RegExp(query, 'i') } },
                    { info: { $regex: new RegExp(query, 'i') } }
                ]
            });
            console.log(result);
            if (result.length === 0) {
                throw createError.NotFound('Không tìm thấy thông tin cây');
            }
            return res.status(200).json({
                result
            });
        } catch (error) {
            next(error);
        }
    }

}