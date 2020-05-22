const mongoose = require('mongoose')

const questionSchema = new mongoose.Schema({
    questions: [{
        engQuestion: {
            type: String,
            required: true
        },
        bngQuestion: {
            type: String,
            required: true
        }
    }],
    problem: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Problem',
        unique: true,
    }
})

const Questions = mongoose.model('Questions', questionSchema)

module.exports = Questions