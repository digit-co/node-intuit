request = require "request"
OAuth = require "./oauth"
SAML_URL = "https://oauth.intuit.com/oauth/v1/get_access_token_by_saml"

respond = (done) ->
  (err, response, body) ->
    if process.env.NODE_DEBUG
      console.log body
      console.log "=> Error: ", "#{err?.statusCode} #{body.statusMessage}" if err
    done err, body

module.exports = class Request
  constructor: (@options) ->
    @oauth = new OAuth @options

  _params: (method, url, done) ->
    @oauth.getToken (err, token, tokenSecret) =>
      return done err if err
      params =
        method: method
        uri: url
        headers:
          "Content-Type": "application/json"
        oauth:
          consumer_key: @options.consumerKey
          consumer_secret: @options.consumerSecret
          token: token
          token_secret: tokenSecret
      done err, params

  get: (url, body, done) ->
    @_params "GET", url, (err, params) ->
      return done err if err
      request params, respond done

  post: (url, body, done) ->
    @_params "POST", url, (err, params) ->
      return done err if err
      params.body = body
      request params, respond done

  put: (url, body, done) ->
    @_params "PUT", url, (err, params) ->
      return done err if err
      params.body = body
      request params, respond done

  delete: (url, body, done) ->
    @_params "DELETE", url, (err, params) ->
      return done err if err
      request params, respond done
