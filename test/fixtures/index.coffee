_ = require "lodash"
nock = require "nock"
config = require "../config"
path = require "path"
fs = require "fs"

load = (fileName) ->
  nock.load path.resolve __dirname, "./#{fileName}.json"

oauth = ->
  nock("https://oauth.intuit.com:443")
    .filteringRequestBody((body) -> return "SAML")
    .post("/oauth/v1/get_access_token_by_saml", "SAML")
    .matchHeader("Authorization", authorizationHeader)
    .reply(200, "oauth_token_secret=L63cI4q5UhP4mQzpCi1RHBMSLe2TNOaI98vxyIBL&oauth_token=qyprdcvDh5V2XoJRwYmxxdL5vOJ54Z6sNVohlNLQHyyhHaAy")

jsonHeader = (header) ->
  header is "application/json"

signedHeader = (header) ->
  /oauth_signature/.test header

authorizationHeader = (header) ->
  regex = new RegExp "#{config.consumerKey}"
  regex.test header

fixtures =
  oauth: oauth

  signedJson: ->
    oauth()
    nock("https://financialdatafeed.platform.intuit.com:443")
      .get("/v1/institutions/100000")
      .matchHeader("Content-Type", jsonHeader)
      .matchHeader("Accept", jsonHeader)
      .matchHeader("Authorization", signedHeader)
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

  getAccountTransactions: ->
    oauth()
    load "getAccountTransactions"

  getAccountTransactions_startDate: ->
    oauth()
    load "getAccountTransactions_startDate"

  getAccountTransactions_dateRange: ->
    oauth()
    load "getAccountTransactions_dateRange"

  deleteCustomer: ->
    oauth()
    load "deleteCustomer"

  discoverAndAddAccounts: ->
    oauth()
    load "discoverAndAddAccounts"

  discoverAndAddAccountsMfa: ->
    oauth()
    load "discoverAndAddAccountsMfa"

  discoverAndAddAccountsWrongPassword: ->
    oauth()
    load "discoverAndAddAccountsWrongPassword"

  discoverAndAddAccountsRateLimit: ->
    oauth()
    load "discoverAndAddAccountsRateLimit"

  handleMfa: ->
    oauth()
    load "handleMfa"

  updateInstitutionLogin: ->
    oauth()
    load "updateInstitutionLogin"

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
