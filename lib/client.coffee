_ = require "lodash"
Request = require "./request"

BASE_URL = "https://financialdatafeed.platform.intuit.com/v1"

zeroBased = (number) ->
  ("0" + number).slice(-2)

# 2015-07-29
formatDate = (date) ->
  year = date.getFullYear()
  month = zeroBased date.getMonth() + 1
  day = zeroBased date.getDate()
  "#{year}-#{month}-#{day}"

handleAccountsResponse = (response, done) ->
  if response.challenge
    done null, response
  else
    done null, response.accounts

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
    @request "post", "/institutions/#{institutionId}/logins", credentials, (err, response) ->
      return done err if err
      handleAccountsResponse response, done

  handleMfa: (userId, institutionId, challengeSessionId, challengeNodeId, answers, done) ->
    @options.headers =
      challengeSessionId: challengeSessionId
      challengeNodeId: challengeNodeId
    @request "post", "/institutions/#{institutionId}/logins", answers, (err, response) ->
      return done err if err
      done err, response.accounts

  getCustomerAccounts: (userId, done) ->
    @options.userId = userId
    @request "get", "/accounts", (err, response) ->
      return done err if err
      done err, response.accounts

  getAccount: (userId, accountId, done) ->
    @options.userId = userId
    @request "get", "/accounts/#{accountId}", (err, response) ->
      return done err if err
      done err, _.first response.accounts

  # Download last week of transactions unless a date range is specified
  # If no endDate is specified, startDate to current is downloaded
  getAccountTransactions: (userId, accountId, startDate, endDate, done) ->
    oneWeekAgo = -10080
    defaultStartDate = formatDate new Date(new Date().getTime() + oneWeekAgo * 60000)

    if typeof(startDate) is "function"
      [startDate, endDate, done] = [defaultStartDate, null, startDate]
    else if typeof(endDate) is "function"
      [startDate, endDate, done] = [formatDate(startDate), null, endDate]
    else
      [startDate, endDate, done] = [formatDate(startDate), formatDate(endDate), done]

    url = "/accounts/#{accountId}/transactions?txnStartDate=#{startDate}"
    url += "&txnEndDate=#{endDate}" if endDate

    @options.userId = userId
    @request "get", url, (err, response) ->
      return done err if err
      done err, response.bankingTransactions

  updateInstitutionLogin: (userId, institutionId, loginId, credentials, done) ->
    @options.userId = userId
    @request "put", "/logins/#{loginId}?refresh=true", credentials, (err, response) ->
      return done err if err
      handleAccountsResponse response, done

  deleteAccount: (userId, accountId, done) ->
    @options.userId = userId
    @request "delete", "/accounts/#{accountId}", done

  deleteCustomer: (userId, done) ->
    @options.userId = userId
    @request "delete", "/customers", done
