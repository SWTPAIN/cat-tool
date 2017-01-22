var jsonServer = require('json-server')

// Returns an Express server
var server = jsonServer.create()

// Set default middlewares (logger, static, cors and no-cache)
server.use(jsonServer.defaults())

var router = jsonServer.router('db.json')

server.use(jsonServer.bodyParser)
server.use(function (req, res, next) {
  if (req.path === '/login') {
    const {email, password} = req.body;
    if (email === 'alice@oneskyapp.com' && password === "password") {
      return res.send({id: '1', name: 'Alice', email: 'alice@oneskyapp.com'});
    }
  }
  // if (req.method === 'POST') {
  //   req.body.createdAt = Date.now()
  // }
  // Continue to JSON Server router
  next()
})
server.use(router)

console.log('Listening at 3000')

server.listen(3000)
