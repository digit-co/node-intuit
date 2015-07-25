request = require "request"
nonce = require("nonce")()
{sign} = require("oauth-sign")
Saml = require "./saml"

SAML_URL = "https://oauth.intuit.com/oauth/v1/get_access_token_by_saml"
ENCODING = "base64"

module.exports = class OAuth
  constructor: (@options) ->
    @saml = new Saml(@options).signAssertion()

  parseResponse: (responseBody) ->
    [oauthTokenSecret, oauthToken] = responseBody.split "&"
    tokenSecret = oauthTokenSecret?.split("=")?[1]
    token = oauthToken?.split("=")?[1]
    return {token, tokenSecret}

  getToken: (done) ->
    params =
      uri: SAML_URL
      method: "POST"
      headers:
        "Authorization": "OAuth oauth_consumer_key=\"#{@options.consumerKey}\""
      form:
        saml_assertion: @saml
    request params, (err, response, body) =>
      return done err if err
      oauth = @parseResponse body
      done err, oauth.token, oauth.tokenSecret
