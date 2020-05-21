const mongoose = require('mongoose')
const validator = require('validator')
const bcrypt = require('bcryptjs')
const jwt = require('jsonwebtoken')

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
    age: {
        type: Number,
        required: false,
        default: 0,
    },
    gender: {
        type: String,
        required: true,
    },
    tokens: [{ token: { type: String, required: true } }]
})

// generate instance based methods

userSchema.methods.generateAuthToken = async function() {
    const user = this
    const token = jwt.sign({ _id: user._id }, 'abc123', { 'expiresIn': '2 weeks' })
    user.tokens = user.tokens.concat({ token })
    await user.save()
    return token
}

userSchema.methods.checkAuth = function(token) {
    const user = this
    const filtered = user.tokens.filter((tokens) => tokens.token == token)
    if (filtered.length > 0) {
        return true
    }
    return false
}

userSchema.methods.toJson = function() {
    var object = this.toObject()
    delete object.password
    delete object.tokens
    return object
}

userSchema.pre('save', async function(next) {
    const user = this

    if (user.isModified('password')) {
        user.password = await bcrypt.hash(user.password, 8)
    }

    next()
})

const User = mongoose.model('User', userSchema)

module.exports = User