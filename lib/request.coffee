request = require "request"
_ = require "lodash"
debug = require("debug")("node-intuit:request")
OAuth = require "./oauth"
SAML_URL = "https://oauth.intuit.com/oauth/v1/get_access_token_by_saml"

module.exports = class Request
  constructor: (@options) ->
    @oauth = new OAuth @options

  _params: (method, url, done) ->
    @oauth.getToken (err, token, tokenSecret) =>
      return done err if err
      optionalHeaders = @options.headers or {}
      headers =
        "Content-Type": "application/json"
        "Accept": "application/json"
      params =
        method: method
        uri: url
        json: true
        oauth:
          consumer_key: @options.consumerKey
          consumer_secret: @options.consumerSecret
          token: token
          token_secret: tokenSecret
      params.headers = _.merge headers, optionalHeaders
      done err, params

  request: (params, done) ->
    method = if params.method is "DELETE" then params.method.toLowerCase()[0..2] else params.method.toLowerCase()
    requestMethod = request[method]
    requestMethod params, (err, response, body) ->
      return done err if err
      debug "#{params.method} #{response.request.uri.path} - #{response.statusCode} #{response.statusMessage}"
      if response.statusCode is 503
        return done new Error "#{response.body.errorInfo[0].errorCode} - #{response.body.errorInfo[0].errorMessage}"
      else if response.statusCode is 401
        {challengenodeid, challengesessionid} = response.headers
        done err, {challenge: body.challenge, challengeNodeId: challengenodeid, challengeSessionId: challengesessionid}
      else if response.statusCode is 429
        done new Error "API requests have exceeded the throttling limit."
      else
        return done err, body if body
        done err, response.statusCode

  get: (url, body, done) ->
    @_params "GET", url, (err, params) =>
      return done err if err
      @request params, done

  post: (url, body, done) ->
    @_params "POST", url, (err, params) =>
      return done err if err
      params.body = body
      @request params, done

  put: (url, body, done) ->
    @_params "PUT", url, (err, params) =>
      return done err if err
      params.body = body
      @request params, done

  delete: (url, body, done) ->
    @_params "DELETE", url, (err, params) =>
      return done err if err
      @request params, done
