const path = require('path')
const express = require('express')
const hbs = require('hbs')
const bodyParser = require('body-parser')
const auth = require('./middleware/auth')

// run db
require('./db/mongoose')

// models
const User = require('./models/user')

//session handle
var session = require('express-session')
var cookieParser = require('cookie-parser');

// path setup
const publicPath = path.join(__dirname, '../public')
const viewsPath = path.join(__dirname, '../templates/views')
const partialsPath = path.join(__dirname, '../templates/partials')

// express configuration

const app = express()

app.set('trust proxy', 1)
app.use(cookieParser())
app.use(session({
    secret: 'keyboard cat',
    resave: false,
    saveUninitialized: true,
    cookie: {
        path: '/',
        httpOnly: false,
        maxAge: 8 * 60 * 60 * 1000
    }
}))
app.use(bodyParser.urlencoded({ extended: true }))
app.use(bodyParser.json())
app.use(express.static(publicPath))
app.set('view engine', 'hbs')
app.set('views', viewsPath)
hbs.registerPartials(partialsPath)

app.get('', (req, res) => {
    if (req.session.user_id) {
        res.redirect('/home')
    } else {
        res.render('index', { title: "Mental Health Analysis" })
    }
})

app.get('/home', auth, (req, res) => {
    res.render('home', { title: 'Home', loggedIn: true, catagory: ['Problems', 'Questions', 'Users', 'Responses'] })
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

app.post('/logout', auth, (req, res) => {
    req.session.destroy()
    return res.redirect('/')
})

app.post('/signin', async(req, res) => {
    const user = await User.findOne({ email: req.body.email })
    if (user.password == req.body.password) {
        req.session.user_id = user._id
        res.redirect('/home')
    } else {
        res.redirect('/signin')
    }
})

app.listen(3000, () => {
    console.log('Server is up on port 3000')
})