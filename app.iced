express = require "express"
socket  = require "socket.io"
stylus  = require "stylus"
coffee  = require "coffee-middleware"
nib     = require "nib"
http    = require "http"
redis   = require "redis"

cfg     = require "./config"

passport     = require "passport" 
cookieParser = require "cookie-parser"
session      = require "express-session"
store        = require("connect-redis") session
# store        = require("session-file-store") session

auth = require "./routers/auth"
api  = require "./routers/api"

app = express()
srv = http.Server app
io  = socket srv

console.log "Listen #{cfg.port}"
srv.listen cfg.port

compile = (str, path)->
    stylus(str)
    .set("filename", path)
    .use(nib())

app.set "views"      , "#{__dirname}/views"
app.set "view engine", "pug"

app.use stylus.middleware
    src: "#{__dirname}/public"
    compile: compile

app.use coffee
    src: "#{__dirname}/public"
    compress: true

# PASSPORT

app.use cookieParser()
rdb = redis.createClient()
app.use session 
    store: new store(host:"localhost", port: 6379, client: rdb )
    secret:"catdancinghere"
    resave: true
    saveUninitialized: true
app.use passport.initialize()
app.use passport.session()

app.use "/auth", auth
app.use "/api" , api

app.use express.static "#{__dirname}/public"

app.get "/", (req,res)->
    res.render "index",
        title: "index"
        req  : req
        cfg  : cfg

app.get '/logout',(req, res)->
    req.logout()
    res.redirect '/'

console.log cfg
# SOCKETS
# io.on "connection", (socket)->
#     socket.emit "news", helllo: "world"
#     socket.on "hello", (data)->
#         console.log data

