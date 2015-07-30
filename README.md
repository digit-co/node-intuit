# node-intuit

WIP `npm` port of https://github.com/cloocher/aggcat

### Basic Usage

```coffeescript
fs = require "fs"
path = require "path"
userId = "1"

config =
  issuerId: "issuer-id"
  consumerKey: "consumer-key"
  consumerSecret: "consumer-secret"
  key: fs.readFileSync path.join(__dirname, "app.key"), "utf8"
  certificate: fs.readFileSync path.join(__dirname, "app.crt"), "utf8"
  certificatePassword: "password"

intuit = require("intuit")(config)

intuit.getInstitutionDetails userId, 100000, (err, institutionDetails) ->
  console.log institutionDetails
  process.exit()
```

Debug with `DEBUG=intuit*`.
