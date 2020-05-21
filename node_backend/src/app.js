const path = require('path')
const express = require('express')
const hbs = require('hbs')
const bodyParser = require('body-parser')
const bcrypt = require('bcryptjs')
const api_auth = require('./middleware/api_auth')

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

// api section

app.post('/user', async(req, res) => {
    try {
        const user = new User(req.body)
        await user.save()
        const token = await user.generateAuthToken()
        var object = user.toJson()
        res.status(201).send({ user: object, token })
    } catch (e) {
        res.status(502).send(e)
    }
})

app.get('/user/me', api_auth, async(req, res) => {
    try {
        const user = await User.findById(req.user_id)
        if (!user) {
            return res.status(400).send()
        }
        const isAuth = user.checkAuth(req.token)
        if (isAuth) {
            var object = user.toJson()
            return res.status(201).send({ user: object })
        } else {
            res.status(401).send()
        }
    } catch (e) {
        res.status(502).send(e)
    }
})

app.post('/user/login', async(req, res) => {
    try {
        const user = await User.findOne({ email: req.body.email })

        if (!user) {
            return res.status(400).send()
        }
        const isMatch = await bcrypt.compare(req.body.password, user.password)
        if (!isMatch) {
            return res.status(401).send()
        }
        const token = await user.generateAuthToken()
        var object = user.toJson()
        return res.status(201).send({ user: object, token })
    } catch (e) {
        res.status(502).send(e)
    }
})

app.post('/user/logout', api_auth, async(req, res) => {
    try {
        const user = await User.findById(req.user_id)
        const isAuth = user.checkAuth(req.token)
        if (isAuth) {
            const tokens = user.tokens.filter((tokens) => tokens.token != req.token)
            user.tokens = tokens
            await user.save()
            res.status(200).send()
        } else {
            res.status(401).send()
        }
    } catch (e) {
        res.status(502).send(e)
    }
})

app.post('/user/logoutAll', api_auth, async(req, res) => {
    try {
        const user = await User.findById(req.user_id)
        const isAuth = user.checkAuth(req.token)
        if (isAuth) {
            user.tokens = []
            await user.save()
            res.status(200).send()
        } else {
            res.status(401).send()
        }
    } catch (e) {
        res.status(502).send(e)
    }
})