Request = require "./request"

BASE_URL = "https://financialdatafeed.platform.intuit.com/v1"

module.exports = class IntuitClient
  constructor: (@options) ->

  request: (method, path, body, done) ->
    [body, done] = [{}, body] if typeof(body) is "function"
    new Request(@options)[method]("#{BASE_URL}#{path}", body, done)

  institutions: (userId, done) ->
    @options.userId = userId
    @request "get", "/institutions", (err, response) ->
      return done err if err
      done err, response.institution

  getInstitutionDetails: (userId, institutionId, done) ->
    @options.userId = userId
    @request "get", "/institutions/#{institutionId}", done

  discoverAndAddAccounts: (userId, institutionId, credentials, done) ->
    @options.userId = userId
    @request "post", "/institutions/#{institutionId}/logins", credentials, done

  getCustomerAccounts: (userId, done) ->
    @options.userId = userId
    @request "get", "/accounts", (err, response) ->
      return done err if err
      done err, response.accounts

  getAccount: (userId, accountId, done) ->
    @options.userId = userId
    @request "get", "/accounts/#{accountId}", done

  getAccountTransactions: (userId, accountId, startDate, endDate) ->
    @options.userId = userId
    @request "get", "/accounts/#{accountId}/transactions", done

  updateInstitutionLogin: (userId, institutionId, loginId, credentials, done) ->
    @options.userId = userId
    @request "put", "/logins/#{loginId}?refresh=true", credentials, done

  deleteAccount: (userId, accountId, done) ->
    @options.userId = userId
    @request "delete", "/accounts/#{accountId}", done

  deleteCustomer: (userId, done) ->
    @options.userId = userId
    @request "delete", "/customers", done
