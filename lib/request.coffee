request = require "request"
OAuth = require "./oauth"

respond = (done) ->
  (err, response, body) ->
    if process.env.DEBUG
      console.log "=> Error: ", err if err
      console.log "=> Response Code: ", response.statusCode
      console.log "=> Response Body: ", escape body
      console.log "=> Request Headers: ", response.request.headers
    done err, body

module.exports = class Request
  constructor: (@options) ->
    @oauth = new OAuth @options

  _params: (method, url, done) ->
    @oauth.sign method, url, (err, signature) ->
      return done err if err
      params =
        method: method
        uri: url
        headers:
          "Content-Type": "application/json"
          "Authentication": signature
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
