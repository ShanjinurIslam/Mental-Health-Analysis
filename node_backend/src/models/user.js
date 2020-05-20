const mongoose = require('mongoose')
const validator = require('validator')

const userSchema = new mongoose.Schema({
    username: {
        type: String,
        required: true,
        trim: true,
        lowercase: true
    },
    email: {
        type: String,
        unique: true,
        required: true,
        trim: true,
        lowercase: true,
        validate(value) {
            if (!validator.default.isEmail(value)) {
                throw new Error('Invalid Email Address')
            }
        }
    },
    password: {
        type: String,
        required: true,
        minlength: 6,
        trim: true,
        validate(value) {
            if (value.toLowerCase().includes('password')) {
                throw new Error('Password is set \'password\'')
            }
        }
    },
})

const User = mongoose.model('User', userSchema)

module.exports = User