# node-intuit

WIP `npm` port of https://github.com/cloocher/aggcat

### Basic Usage

```coffeescript
# script.coffee
fs = require "fs"
path = require "path"

config =
  issuerId: "issuer-id"
  consumerKey: "consumer-key"
  consumerSecret: "consumer-secret"
  userId: "1"
  key: fs.readFileSync path.join(__dirname, "app.key"), "utf8"
  certificate: fs.readFileSync path.join(__dirname, "app.crt"), "utf8"
  certificatePassword: "password"

intuit = require("intuit")(config)

intuit.getInstitutionDetails 100000, (err, institutionDetails) ->
  console.log institutionDetails
  process.exit()
```
