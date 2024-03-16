const mongoose = require('mongoose')
const Schema = mongoose.Schema;
const bcrypt = require('bcrypt');
const { Connection } = require('../Helper/connections_mongoodb')

const Admin = new Schema({
    username: {
        type: String,
        required: true
    },
    password: {
        type: String,
        required: true
    }
})

Admin.pre('save', async function (next) {
    if (!this.isModified('password')) {
        return next();
    }

    try {
        const salt = await bcrypt.genSalt(10);
        const hashPassword = await bcrypt.hash(this.password, salt);
        this.password = hashPassword;
        next();
    } catch (error) {
        next(error);
    }
});

Admin.methods.isCheckPassword = async function (password) {
    try {
        return bcrypt.compare(password, this.password);
    } catch (error) {
        next(error)
    }
}

module.exports = Connection.model('Admin', Admin);