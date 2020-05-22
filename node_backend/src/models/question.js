const mongoose = require('mongoose')

const questionSchema = new mongoose.Schema({
    questions: [{
        question: {
            type: String,
            required: true
        }
    }],
    problem: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Problem'
    }
})

const Questions = mongoose.model('Questions', questionSchema)

module.exports = Questions