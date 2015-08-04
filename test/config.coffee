path = require "path"
fs = require "fs"

module.exports =
  issuerId: "issuer-id"
  consumerKey: "consumer-key"
  consumerSecret: "consumer-secret"
  key: fs.readFileSync path.join(__dirname, "./fixtures/test.key"), "utf8"
  certificate: fs.readFileSync path.join(__dirname, "./fixtures/test.crt"), "utf8"
  certificatePassword: "test"
