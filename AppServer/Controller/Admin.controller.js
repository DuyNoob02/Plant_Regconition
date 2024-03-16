const Admin = require('../Model/Admin.model')
const createError = require('http-errors');
const { signAccessToken, signRefreshToken, verifyRefreshToken } = require('../Helper/JWT_service');
const client = require('../Helper/connections_redis');


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
    }
}