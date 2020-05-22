const path = require('path')
const express = require('express')
const hbs = require('hbs')
const bodyParser = require('body-parser')
const bcrypt = require('bcryptjs')
const multer = require('multer');
const csv = require('fast-csv');
const fs = require('fs');

const api_auth = require('./middleware/api_auth')

const auth = require('./middleware/auth')

// run db
require('./db/mongoose')

// models
const User = require('./models/user')
const Problem = require('./models/problem')
const Question = require('./models/question')

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
hbs.registerHelper('capitalize', function(str) {
    return str.charAt(0).toUpperCase() + str.slice(1)
});
hbs.registerHelper('toLowerCase', function(str) {
    return str.toLowerCase()
});

// set up upload section
const upload = multer({ dest: 'csv' });


app.get('', (req, res) => {
    if (req.session.user_id) {
        res.redirect('/home')
    } else {
        res.render('index', { title: "Mental Health Analysis" })
    }
})

app.get('/home', auth, (req, res) => {
    res.render('home', { title: 'Home', loggedIn: true, catagory: ['Problems', 'Questions', 'Scores', 'Users', 'Responses'] })
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
    const isMatch = await bcrypt.compare(req.body.password, user.password)
    if (isMatch) {
        req.session.user_id = user._id
        res.redirect('/home')
    } else {
        res.redirect('/')
    }
})

app.listen(3000, () => {
    console.log('Server is up on port 3000')
})

app.post('/problems', auth, async(req, res) => {
    try {
        const problem = new Problem(req.body)
        await problem.save()
        res.redirect('/Problems')
    } catch (e) {
        req.e = e
        res.redirect('/Problems')
    }
})

app.get('/problems', auth, async(req, res) => {
    const problems = await Problem.find({})
    res.render('problem', { title: 'Problems', loggedIn: true, problems })
})

app.get('/questions', auth, async(req, res) => {
    const problems = await Problem.find({})
    var questions = await Question.find({})

    const filled = []

    questions.forEach(element => {
        filled.push(element.problem.toString())
    });

    for (var i in questions) {
        questions[i].problem = await Problem.findById(questions[i].problem)
    }

    const filtered = problems.filter((problem) => !filled.includes(problem._id.toString()))

    res.render('question', { title: 'Questions', loggedIn: true, problems: filtered, questions: questions })
})

app.post('/questions', [auth, upload.single('file')], async(req, res) => {
    const problem_id = req.body.problem_id
    const problem = await Problem.findById(problem_id)
    const csv_path = req.file.path;
    const arr = []
    fs.createReadStream(csv_path)
        .pipe(csv.parse({ headers: true }))
        .on('error', error => console.error(error))
        .on('data', row => {
            arr.push(row)
        })
        .on('end', async() => {
            const object = {
                questions: arr,
                problem: problem
            }

            try {
                const question = new Question(object)
                console.log(question)
                await question.save()
            } catch (e) {
                console.log(e)
            }
        });
    res.redirect('/questions')

})

// api section

app.post('/api/user', async(req, res) => {
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

app.get('/api/user/me', api_auth, (req, res) => {
    var object = req.user.toJson()
    return res.status(201).send({ user: object })
})

app.post('/api/user/login', async(req, res) => {
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

app.post('/api/user/logout', api_auth, async(req, res) => {
    try {
        const user = req.user
        const tokens = user.tokens.filter((tokens) => tokens.token != req.token)
        user.tokens = tokens
        await user.save()
        res.status(200).send()
    } catch (e) {
        res.status(400).send(e)
    }
})

app.post('/api/user/logoutAll', api_auth, async(req, res) => {
    try {
        const user = req.user
        user.tokens = []
        await user.save()
        res.status(200).send()
    } catch (e) {
        res.status(400).send(e)
    }
})