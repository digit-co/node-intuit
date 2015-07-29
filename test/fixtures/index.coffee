_ = require "lodash"
nock = require "nock"
path = require "path"
fs = require "fs"

load = (fileName) ->
  nock.load path.resolve __dirname, "./#{fileName}.json"

oauth = ->
  nock("https://oauth.intuit.com:443")
    .filteringRequestBody((body) -> return "SAML")
    .post("/oauth/v1/get_access_token_by_saml", "SAML")
    .reply(200, "oauth_token_secret=L63cI4q5UhP4mQzpCi1RHBMSLe2TNOaI98vxyIBL&oauth_token=qyprdcvDh5V2XoJRwYmxxdL5vOJ54Z6sNVohlNLQHyyhHaAy")

fixtures =
  oauth: oauth

  # Fail the test if these headers aren't generated
  signedJson: ->
    oauth()
    nock("https://financialdatafeed.platform.intuit.com:443", {
      reqheaders:
        "Content-Type": "application/json"
        "Accept": "application/json"
    })
      .get("/v1/institutions/100000")
      .matchHeader("Authorization", (header) ->
        /oauth_signature/.test header
      )
      .reply(200, {})

  getInstitutionDetails: ->
    oauth()
    load "getInstitutionDetails"

  institutions: ->
    oauth()
    load "institutions"

  deleteAccount: ->
    oauth()
    load "deleteAccount"

  getCustomerAccounts: ->
    oauth()
    load "getCustomerAccounts"

  getAccount: ->
    oauth()
    load "getAccount"

module.exports =
  record: ->
    nock.recorder.rec
      output_objects: true
      dont_print: true

  save: (fileName) ->
    fs.writeFileSync path.resolve(__dirname, "./#{fileName}.json"), JSON.stringify(nock.recorder.play(), null, 2)

  load: (fixture, times=1) ->
    mock = fixtures[fixture]
    loadMock = ->
      return mock() if mock
      load fixture
    _.times times, loadMock
