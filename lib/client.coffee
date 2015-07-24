Request = require "./request"

BASE_URL = "https://financialdatafeed.platform.intuit.com/v1"


module.exports = class IntuitClient
  constructor: (@options) ->

  request: (method, path, body, done) ->
    [body, done] = [{}, body] if typeof(body) is "function"
    new Request(@options)[method]("#{BASE_URL}#{path}", body, done)

  institutions: (done) ->
    @request "get", "/institutions", done

  getInstitutionDetails: (institutionId, done) ->
    @request "get", "/institutions/#{institutionId}", done

  discoverAndAddAccounts: (institutionId, credentials, done) ->
    @request "post", "/institutions/#{institutionId}/logins", credentials, done

  getCustomerAccounts: (done) ->
    @request "get", "/accounts", done

  getAccount: (accountId, done) ->
    @request "get", "/accounts/#{accountId}", done

  getAccountTransactions: (accountId, startDate, endDate) ->
    @request "get", "/accounts/#{accountId}/transactions", done

  updateInstitutionLogin: (institutionId, loginId, credentials, done) ->
    @request "put", "/logins/#{loginId}?refresh=true", credentials, done

  deleteAccount: (accountId, done) ->
    @request "delete", "/accounts/#{accountId}", done

  deleteCustomer: ->
    @request "delete", "/customers", done
