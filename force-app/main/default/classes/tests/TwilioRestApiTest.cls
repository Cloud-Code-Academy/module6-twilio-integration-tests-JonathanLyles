/**
 * TwilioRestApiTest - Test class for TwilioRestApi
 * @see TwilioRestApi
 */
@IsTest
private class TwilioRestApiTest {
  /**
   * Test handleIncomingSMS method with standard SMS parameters
   */
  @IsTest
  static void testHandleIncomingSMSStandard() {
    // - Create RestRequest and RestResponse objects
    RestRequest request = new RestRequest();
    // - Set requestURI (e.g., '/services/apexrest/twilio/sms')
    request.requestURI = '/services/apexrest/twilio/sms';
    // - Set httpMethod to 'POST'
    request.httpMethod = 'POST';
    // - Add required parameters (MessageSid, AccountSid, From, To, Body, etc.)
    request.addParameter('MessageSid', 'TestMessageSid');
    request.addParameter('AccountSid', 'TestAccountSid');
    request.addParameter('From', '+5555555555');
    request.addParameter('To', '+4444444444');
    request.addParameter('Body', 'Test message');

    RestResponse response = new RestResponse();

    RestContext.request = request;
    RestContext.response = response;

    Test.startTest();

    String twilioResponse = TwilioRestApi.handleIncomingSMS();

    Test.stopTest();

    System.debug(twilioResponse);

    // - Verify response XML is not null
    // - Verify response contains expected TwiML elements
    Assert.areNotEqual(null, twilioResponse, 'Error: twilioResponse was null');
    Assert.areEqual(
      true,
      twilioResponse.contains('<Response>'),
      'Error: <Response> element missing from twilioResponse'
    );
  }

  /**
   * Test handleIncomingSMS method with media attachments
   */
  @IsTest
  static void testHandleIncomingSMSWithMedia() {
    // - Create RestRequest and RestResponse objects
    RestRequest request = new RestRequest();
    RestResponse response = new RestResponse();
    // - Set requestURI and httpMethod
    request.requestURI = '/services/apexrest/twilio/sms';
    request.httpMethod = 'POST';
    // - Add required parameters
    request.addParameter('MessageSid', 'TestMessageSid');
    request.addParameter('AccountSid', 'TestAccountSid');
    request.addParameter('From', '+5555555555');
    request.addParameter('To', '+4444444444');
    request.addParameter('Body', 'Test message');

    // - Add media attachment parameters (NumMedia, MediaUrl0, MediaContentType0, etc.)
    request.addParameter('NumMedia', '1');
    request.addParameter(
      'MediaUrl0',
      'https://api.twilio.com/2010-04-01/Accounts/AC123/Messages/MM123/Media/MEXXXXX'
    );
    request.addParameter('MediaContentType0', 'image/jpeg');

    RestContext.request = request;
    RestContext.response = response;

    Test.startTest();
    // - Call TwilioRestApi.handleIncomingSMS()
    String twilioResponse = TwilioRestApi.handleIncomingSMS();
    Test.stopTest();
    // - Verify response XML is not null
    Assert.areNotEqual(null, TwilioResponse, 'Error: TwilioResponse is null');
    // - Verify response contains expected TwiML elements
    Assert.areEqual(
      true,
      TwilioResponse.contains('<Response>'),
      'Error: <Response> element missing from twilioResponse'
    );
  }

  /**
   * Test handleIncomingSMS method with location data
   */
  @IsTest
  static void testHandleIncomingSMSWithLocation() {
    // - Create RestRequest and RestResponse objects
    RestRequest request = new RestRequest();
    RestResponse response = new RestResponse();
    // - Set requestURI and httpMethod
    request.requestURI = '/services/apexrest/twilio/sms';
    request.httpMethod = 'POST';
    // - Add required parameters
    request.addParameter('MessageSid', 'TestMessageSid');
    request.addParameter('AccountSid', 'TestAccountSid');
    request.addParameter('From', '+5555555555');
    request.addParameter('To', '+4444444444');
    request.addParameter('Body', 'Test message');
    // - Add location parameters (FromCity, FromState, FromZip, FromCountry, etc.)
    request.addParameter('FromCity', 'TestCity');
    request.addParameter('FromState', 'TestState');
    request.addParameter('FromZip', '90210');
    request.addParameter('FromCountry', 'USA');

    RestContext.request = request;
    RestContext.response = response;

    Test.startTest();
    // - Call TwilioRestApi.handleIncomingSMS()
    String twilioResponse = TwilioRestApi.handleIncomingSMS();

    Test.stopTest();

    // - Verify response XML is not null
    // - Verify response contains expected TwiML elements
    Assert.areNotEqual(null, twilioResponse, 'Error: twilioResponse was null');
    Assert.areEqual(
      true,
      twilioResponse.contains('<Response>'),
      'Error: <Response> element missing from twilioResponse'
    );
  }

  /**
   * Test handleIncomingSMS method with WhatsApp parameters
   */
  @IsTest
  static void testHandleIncomingSMSWithWhatsApp() {
    // - Create RestRequest and RestResponse objects
    RestRequest request = new RestRequest();
    RestResponse response = new RestResponse();
    // - Set requestURI and httpMethod
    request.requestURI = '/services/apexrest/twilio/sms';
    request.httpMethod = 'POST';
    // - Add required parameters
    request.addParameter('MessageSid', 'TestMessageSid');
    request.addParameter('AccountSid', 'TestAccountSid');
    // - Add required parameters with WhatsApp format (e.g., From: 'whatsapp:+15551234567')
    request.addParameter('From', 'whatsapp:+15555555555');
    request.addParameter('To', 'whatsapp: +14444444444');
    request.addParameter('Body', 'Hello WhatsApp - Here\'s my location');

    // - Add WhatsApp specific parameters (ProfileName, WaId, etc.)
    request.addParameter('ProfileName', 'John Test');
    request.addParameter('WaId', '15551234567');

    // - Add WhatsApp location data if applicable
    request.addParameter('Latitude', '45.5017');
    request.addParameter('Longitude', '-73.5673');
    request.addParameter('Address', 'Montreal, QC');
    request.addParameter('Label', 'John\'s Office');

    RestContext.request = request;
    RestContext.response = response;

    Test.startTest();
    // - Call TwilioRestApi.handleIncomingSMS()
    String twilioResponse = TwilioRestApi.handleIncomingSMS();

    Test.stopTest();

    // - Verify response XML is not null
    Assert.areNotEqual(null, twilioResponse, 'Error - twilioResponse is null');
    // - Verify response contains expected TwiML elements
    Assert.areEqual(
      true,
      twilioResponse.contains('<Response>'),
      'Error - <Response> element is missing from twilioResponse'
    );
  }
}
