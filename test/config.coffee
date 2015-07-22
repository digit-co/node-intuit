path = require "path"
fs = require "fs"

module.exports =
  issuerId: "issuer-id"
  consumerKey: "consumer-key"
  consumerSecret: "consumer-secret"
  userId: "1" # We only have up to 10 in development mode
  key: fs.readFileSync path.join(__dirname, "test.key"), "utf8"
  certificate: fs.readFileSync path.join(__dirname, "test.crt"), "utf8"
  certificatePassword: "test"
