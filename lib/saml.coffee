uuid = require "node-uuid"
moment = require "moment" # TODO: remove this dependency

ENCODING = "base64"

module.exports = class Saml
  constructor: (@options) ->
    date = new Date
    now = date.toISOString()
    fiveMinutesAgo = moment(date).subtract(5, "minutes").toISOString()
    tenMinutesFromNow = moment(date).add(10, "minutes").toISOString()
    @referenceId = uuid.v4().replace /-/g, ""
    @assertion = """
      <saml2:Assertion xmlns:saml2="urn:oasis:names:tc:SAML:2.0:assertion" ID="_#{@referenceId}" IssueInstant="#{now}" Version="2.0">
        <saml2:Issuer>#{@options.issuerId}</saml2:Issuer>
        <saml2:Subject>
          <saml2:NameID Format="urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified">#{@options.userId}</saml2:NameID>
          <saml2:SubjectConfirmation Method="urn:oasis:names:tc:SAML:2.0:cm:bearer"></saml2:SubjectConfirmation>
        </saml2:Subject>
        <saml2:Conditions NotBefore="#{fiveMinutesAgo}" NotOnOrAfter="#{tenMinutesFromNow}">
          <saml2:AudienceRestriction>
            <saml2:Audience>#{@options.issuerId}</saml2:Audience>
          </saml2:AudienceRestriction>
        </saml2:Conditions>
        <saml2:AuthnStatement AuthnInstant="#{now}" SessionIndex="_#{@referenceId}">
          <saml2:AuthnContext>
            <saml2:AuthnContextClassRef>urn:oasis:names:tc:SAML:2.0:ac:classes:unspecified</saml2:AuthnContextClassRef>
          </saml2:AuthnContext>
        </saml2:AuthnStatement>
      </saml2:Assertion>"
    """
    @digest = require("crypto").createHash("sha1").update(@assertion).digest(ENCODING).trim()

  sign: (content) ->
    require("crypto").createSign("RSA-SHA1").update(content).sign({key: @options.key, passphrase: @options.certificatePassword}, ENCODING)

  signAssertion: ->
    signedInfo = """
      <ds:SignedInfo xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
        <ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"></ds:CanonicalizationMethod>
        <ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"></ds:SignatureMethod>
        <ds:Reference URI="#_#{@referenceId}">
          <ds:Transforms>
            <ds:Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"></ds:Transform>
            <ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"></ds:Transform>
          </ds:Transforms>
          <ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"></ds:DigestMethod>
          <ds:DigestValue>#{@digest}</ds:DigestValue>
        </ds:Reference>
      </ds:SignedInfo>
    """
    signature = """
      <ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
        <ds:SignedInfo>
          <ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>
          <ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/>
          <ds:Reference URI="#_#{@referenceId}">
            <ds:Transforms>
              <ds:Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/>
              <ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>
            </ds:Transforms>
            <ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1'/>
            <ds:DigestValue>#{@digest}</ds:DigestValue>
          </ds:Reference>
        </ds:SignedInfo>
        <ds:SignatureValue>#{@sign signedInfo}</ds:SignatureValue>
      </ds:Signature>
    """
    assertionWithSignature = @assertion.replace /saml2:Issuer\>\<saml2:Subject/, "saml2:Issuer>#{signature}<saml2:Subject"
    return new Buffer(assertionWithSignature).toString ENCODING
