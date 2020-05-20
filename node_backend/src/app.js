const path = require('path')
const express = require('express')
const hbs = require('hbs')
const bodyParser = require('body-parser')

// run db
require('./db/mongoose')

// models
const User = require('./models/user')

// path setup
const publicPath = path.join(__dirname, '../public')
const viewsPath = path.join(__dirname, '../templates/views')
const partialsPath = path.join(__dirname, '../templates/partials')

// express configuration

const app = express()

app.use(bodyParser.urlencoded({ extended: true }))
app.use(bodyParser.json())
app.use(express.static(publicPath))
app.set('view engine', 'hbs')
app.set('views', viewsPath)
hbs.registerPartials(partialsPath)

app.get('', (req, res) => {
    res.render('index', { title: "Mental Health Analysis" })
})

app.get('/signin', (req, res) => {
    res.render('signin', { title: 'Sign In' })
})

app.get('/home', (req, res) => {
    res.render('home', { title: 'Home' })
})

app.get('/signup', (req, res) => {
    res.render('signup', { title: 'Sign Up' })
})

app.post('/signup', async(req, res) => {
    try {
        const user = new User(req.body)
        console.log(user)
        await user.save()
        res.redirect('/home')
    } catch (e) {
        console.log(e)
        res.redirect('/signup')
    }
})

app.post('/signin', async(req, res) => {
    const user = await User.findOne({ email: req.body.email })
    if (user.password == req.body.password) {
        res.redirect('/home')
    } else {
        res.redirect('/signin')
    }
})

app.listen(3000, () => {
    console.log('Server is up on port 3000')
})