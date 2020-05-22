const mongoose = require('mongoose')

problemSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
        trim: true,
        unique: true,
        lowercase: true,
    },
})

const Problem = mongoose.model('Problem', problemSchema)

module.exports = Problem