// Load the built-in http module
const http = require('http');
const { version } = require('./package.json'); // import version from package.json

// Define server and response
const server = http.createServer((req, res) => {
  res.statusCode = 200;               // HTTP status 200 = OK
  res.setHeader('Content-Type', 'text/plain'); // Response type
  res.end(`Hello World\nVersion: ${version}\n`);          // Send response
});

// Server listens on port 3000
server.listen(3000, () => {
  console.log('Server running at http://localhost:3000/');
});

