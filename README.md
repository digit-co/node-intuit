# node-intuit

## Synopsis

Inspired by https://github.com/cloocher/aggcat, this is a node module for interacting
with Intuit's Customer Account Data (CAD) API.

## Code Example

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

intuit = require("node-intuit")(config)

intuit.getInstitutionDetails userId, 100000, (err, institutionDetails) ->
  console.log institutionDetails
  process.exit()
```

## Installation

`npm install --save node-intuit`

## API Reference

See the [tests](https://github.com/hellodigit/node-intuit/blob/master/test/api.coffee)
for all APIs with expected responses.

## Tests

`npm test`

Debug with `DEBUG=node-intuit*`.
