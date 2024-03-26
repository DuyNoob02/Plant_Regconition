const Admin = require('../Model/Admin.model')
const createError = require('http-errors');
const { signAccessToken, signRefreshToken, verifyRefreshToken } = require('../Helper/JWT_service');
const client = require('../Helper/connections_redis');
const Plant = require('../Model/Plant.model')
const fs = require('fs');
module.exports = {
    register: async (req, res, next) => {
        try {
            const { username, password } = req.body;
            try {
                const isExist = await Admin.findOne({ username });
                if (isExist) {
                    throw createError.Conflict('Dung do');
                }
            } catch (error) {
                next(error)
            }
            const admin = new Admin({
                username,
                password
            })
            const saved = await admin.save()
            return res.status(200).json({
                saved
            })
        } catch (error) {
            next(error)
        }
    },

    login: async (req, res, next) => {
        try {
            const { username, password } = req.body;
            // console.log(username);
            const user = await Admin.findOne({
                username
            })
            if (!user) {
                throw createError.NotFound('Khong tim thay tai khoan');
            }
            const isValid = await user.isCheckPassword(password);
            // console.log(user._id);
            if (!isValid) {
                throw createError.Unauthorized('Khong xac thuc');
            }
            const accessToken = await signAccessToken(user._id)
            // console.log(accessToken);
            const refreshToken = await signRefreshToken(user._id)
            res.status(200).json({
                accessToken,
                refreshToken,
                username
            })
        } catch (error) {
            next(error)
        }
    },

    logout: async (req, res, next) => {
        try {
            const { refreshToken } = req.body;
            if (!refreshToken) {
                throw createError.BadRequest();
            }
            const { userID } = await verifyRefreshToken(refreshToken);
            client.del(userID.toString(), (err, reply) => {
                if (err) {
                    throw createError.InternalServerError(err);
                }
                res.json({
                    message: 'Logout!'
                })
            })
        } catch (error) {
            next(error)
        }
    },


    getPlant: async (req, res, next) => {
        const pageQuery = req.query.page || 1;
        const count = 10;
        try {

            const result = await Plant.find({
            })
                .skip((pageQuery - 1) * count)
                .limit(count)

            const totalItem = (await Plant.find({})).length
            // console.log(totalItem);
            const totalPage = Math.ceil(totalItem / count);
            if (!result) {
                throw createError.NotFound()
            }
            return res.json({ result, totalPage })
        } catch (error) {
            next(error)
        }
    },

    getPlantByID: async (req, res, next) => {
        const { id } = req.params;
        // const  id  = req.params;
        console.log(id);
        try {
            const result = await Plant.findById(id)
            // console.log(result);
            if (!result) {
                throw createError.NotFound();
            }
            return res.status(200).json({ result })
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

    editPlantInfo: async (req, res, next) => {
        try {
            const { id } = req.params;
            console.log("id",id);
            const { name, scientificName, description, info } = req.body;
            const existingPlant = await Plant.findById({ _id: id });

            if (!existingPlant) {
                throw createError.NotFound("Not found");
            }
            const oldImg = existingPlant.images;
            const newImg = req.files ? req.files.map(file => file.path) : [];
            const imgToUpdate = newImg.length > 0 ? newImg : oldImg;

            const updatedPlant = await Plant.findByIdAndUpdate({ _id: id }, {
                name, scientificName, description, info, images: imgToUpdate
            });
            console.log(updatedPlant);
            if(!updatedPlant){
                throw createError.NotImplemented("Can't to update!")
            }
            res.status(200).json({
                updatedPlant
            })
        } catch (error) {
            next(error)
        }
    }
}