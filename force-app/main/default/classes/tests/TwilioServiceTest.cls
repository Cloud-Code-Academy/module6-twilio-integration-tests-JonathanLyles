/**
 * TwilioServiceTest - Test class for TwilioService
 * @see TwilioService
 * 
 * TODO: Implement test methods to verify the functionality of the TwilioService class
 */
@IsTest
private class TwilioServiceTest {
    
    /**
     * Test the sendSMS method with a valid request
     * 
     * TODO: Implement this test method to verify that sending an SMS works correctly
     */
    @IsTest
    static void testSendSMS() {
        // TODO: Setup test data
        // - Create test phone number and message body
        String toNumber = '+5555555555';
        String fromNumber = '+4444444444';
        String messageBody = 'Message body test';
        
        // TODO: Setup mock callout response
        // - Use TwilioCalloutMock to simulate a successful response
        Integer statusCode = 201;
        String responseBody = '{"account_sid":"AAAA", "status":"received", "body":"' + messageBody + '", "to":"' + toNumber + '","from":"' + fromNumber + '"}';
        Test.setMock(HttpCalloutMock.class,new TwilioCalloutMock(statusCode,responseBody));

        // TODO: Execute the test
        // - Call TwilioService.sendSMS() method
        Test.startTest();

        TwilioResponse twilioResponse = TwilioService.sendSMS(toNumber, messageBody);

        Test.stopTest();
        
        // TODO: Verify results
        // - Verify that response is successful
        // - Verify status code is correct
        // - Verify response body contains expected values (sid, status, etc.)
        Map<String,Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(twilioResponse.body);
        Assert.areEqual(true, twilioResponse.success, 'Expected success to be true, actual: ' + twilioResponse.success);
        Assert.areEqual(201, twilioResponse.statusCode, 'Expected status code 201, actual: ' + twilioResponse.statusCode);
        Assert.areEqual('Message body test', (String) responseMap.get('body'), 'Expected the following body: "Message body test", actual body: ' + (String) responseMap.get('body'));
        Assert.areEqual('AAAA', (String) responseMap.get('account_sid'), 'Expected the following value for account_sid: "AAAA", actual value for account_sid: ' + (String) responseMap.get('account_sid')); 
    }
    
    /**
     * Test the sendSMS method with an error response
     * 
     * TODO: Implement this test method to verify error handling in sendSMS
     */
    @IsTest
    static void testSendSMSError() {
        // TODO: Setup test data
        // - Create test phone number and message body
        // - Create test phone number and message body
        String toNumber = '+5555555555';
        String fromNumber = '+4444444444';
        String messageBody = 'Message body from testSendSMSError';
        
        // TODO: Setup mock callout response
        // - Use TwilioCalloutMock to simulate an error response
        Test.setMock(HttpCalloutMock.class, new TwilioCalloutMock('Error response from testSendSMSError'));

        // TODO: Execute the test
        // - Call TwilioService.sendSMS() method
        Test.startTest();

        TwilioResponse twilioResponse = TwilioService.sendSMS(toNumber, messageBody);

        Test.stopTest();
        
        // TODO: Verify results
        // - Verify that response is not successful
        // - Verify error status code is correct
        // - Verify error message is extracted correctly
         Map<String,Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(twilioResponse.body);
        Assert.areEqual(false, twilioResponse.success, 'Expected success to be false, actual: ' + twilioResponse.success);
        Assert.areEqual(500, twilioResponse.statusCode, 'Expected status code 500, actual: ' + twilioResponse.statusCode);
        Assert.areEqual('Error response from testSendSMSError', (String) responseMap.get('error'), 'Expected the following body: "Error response from testSendSMSError", actual body: ' + (String) responseMap.get('body'));
        Assert.areEqual(null, (String) responseMap.get('account_sid'), 'Expected the following value for account_sid: null, actual value for account_sid: ' + (String) responseMap.get('account_sid')); 

    }
    
    /**
     * Test the getMessages method
     * 
     * TODO: Implement this test method to verify the getMessages functionality
     */
    @IsTest
    static void testGetMessages() {
        // TODO: Setup mock callout response
        Integer statusCode = 200;

        List<Map<String, Object>> messages = new List<Map<String, Object>>{
    new Map<String, Object>{
        'account_sid' => 'test_sid',
        'api_version' => '2010-04-01',
        'body' => 'Sent from your Twilio trial account - Test message from Salesforce 2025-07-29 23:00:27',
        'date_created' => 'Tue, 29 Jul 2025 23:00:27 +0000',
        'date_sent' => 'Tue, 29 Jul 2025 23:00:27 +0000',
        'date_updated' => 'Tue, 29 Jul 2025 23:00:28 +0000',
        'direction' => 'outbound-api',
        'error_code' => null,
        'error_message' => null,
        'from' => '+4445554444',
        'messaging_service_sid' => null,
        'num_media' => '0',
        'num_segments' => '1',
        'price' => '-0.00830',
        'price_unit' => 'USD',
        'sid' => 'test_sid',
        'status' => 'delivered',
        'to' => '+18777804236',
        'uri' => '/2010-04-01/Accounts/test_sid/Messages/test_token.json'
    },
    new Map<String, Object>{
        'account_sid' => 'test_sid',
        'api_version' => '2010-04-01',
        'body' => 'Sent from your Twilio trial account - Test message from Salesforce 2025-07-29 03:24:09',
        'date_created' => 'Tue, 29 Jul 2025 03:24:09 +0000',
        'date_sent' => 'Tue, 29 Jul 2025 03:24:09 +0000',
        'date_updated' => 'Tue, 29 Jul 2025 03:24:10 +0000',
        'direction' => 'outbound-api',
        'error_code' => null,
        'error_message' => null,
        'from' => '+4445554444',
        'messaging_service_sid' => null,
        'num_media' => '0',
        'num_segments' => '1',
        'price' => '-0.00830',
        'price_unit' => 'USD',
        'sid' => 'test_sid',
        'status' => 'delivered',
        'to' => '+5554445555',
        'uri' => '/2010-04-01/Accounts/test_sid/Messages/test_token.json'
    }
};

Map<String, Object> responseWrapper = new Map<String, Object>{
    'messages' => messages
};

String jsonResponse = JSON.serialize(responseWrapper);
System.debug(jsonResponse);

        // - Use TwilioCalloutMock to simulate a successful response with message list
        Test.setMock(HttpCalloutMock.class,new TwilioCalloutMock(statusCode,jsonResponse));
        // TODO: Execute the test
        // - Call TwilioService.getMessages() method with an appropriate limit
        Test.startTest();

        TwilioResponse twilioResponse = TwilioService.getMessages(50);

        Test.stopTest();
        
        // TODO: Verify results
        Map<String,Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(twilioResponse.body);
        List<Object> messageList = (List<Object>) responseMap.get('messages');
        Map<String, Object> firstMessage = (Map<String, Object>) messageList[0];

        Assert.areEqual(true, twilioResponse.success, 'Expected success to be true, actual: ' + twilioResponse.success);
        Assert.areEqual(200, twilioResponse.statusCode, 'Expected status code 200, actual: ' + twilioResponse.statusCode);
        Assert.areEqual(2, messageList.size(), 'Expected 2 messages, actual: ' + messageList.size());
        Assert.areEqual('test_sid', (String) firstMessage.get('account_sid'), 'Expected the following value for account_sid: "test_sid", actual value for account_sid: ' + (String) firstMessage.get('account_sid')); 
        
    }
    
    /**
     * Test the getMessages method with null/invalid limit
     * 
     * TODO: Implement this test method to verify handling of edge cases
     */
    @IsTest
    static void testGetMessagesWithInvalidLimit() {
       
        // TODO: Setup mock callout response
        Integer statusCode = 200;
       List<Map<String, Object>> messages = new List<Map<String, Object>>{
    new Map<String, Object>{
        'account_sid' => 'test_sid',
        'api_version' => '2010-04-01',
        'body' => 'Sent from your Twilio trial account - Test message from Salesforce 2025-07-29 23:00:27',
        'date_created' => 'Tue, 29 Jul 2025 23:00:27 +0000',
        'date_sent' => 'Tue, 29 Jul 2025 23:00:27 +0000',
        'date_updated' => 'Tue, 29 Jul 2025 23:00:28 +0000',
        'direction' => 'outbound-api',
        'error_code' => null,
        'error_message' => null,
        'from' => '+4445554444',
        'messaging_service_sid' => null,
        'num_media' => '0',
        'num_segments' => '1',
        'price' => '-0.00830',
        'price_unit' => 'USD',
        'sid' => 'test_sid',
        'status' => 'delivered',
        'to' => '+18777804236',
        'uri' => '/2010-04-01/Accounts/test_sid/Messages/test_token.json'
    },
    new Map<String, Object>{
        'account_sid' => 'test_sid',
        'api_version' => '2010-04-01',
        'body' => 'Sent from your Twilio trial account - Test message from Salesforce 2025-07-29 03:24:09',
        'date_created' => 'Tue, 29 Jul 2025 03:24:09 +0000',
        'date_sent' => 'Tue, 29 Jul 2025 03:24:09 +0000',
        'date_updated' => 'Tue, 29 Jul 2025 03:24:10 +0000',
        'direction' => 'outbound-api',
        'error_code' => null,
        'error_message' => null,
        'from' => '+4445554444',
        'messaging_service_sid' => null,
        'num_media' => '0',
        'num_segments' => '1',
        'price' => '-0.00830',
        'price_unit' => 'USD',
        'sid' => 'test_sid',
        'status' => 'delivered',
        'to' => '+5554445555',
        'uri' => '/2010-04-01/Accounts/test_sid/Messages/test_token.json'
    }
};

Map<String, Object> responseWrapper = new Map<String, Object>{
    'messages' => messages
};

String jsonResponse = JSON.serialize(responseWrapper);
System.debug(jsonResponse);
 // - Use TwilioCalloutMock to simulate a successful response with message list
        Test.setMock(HttpCalloutMock.class,new TwilioCalloutMock(statusCode,jsonResponse));

        // TODO: Execute the test with null limit
        // - Call TwilioService.getMessages() method with null
        Test.startTest();
        TwilioResponse nullCase = TwilioService.getMessages(null);

        // TODO: Execute the test with negative limit
        // - Call TwilioService.getMessages() method with a negative number

        TwilioResponse negativeCase = TwilioService.getMessages(-20);

        Test.stopTest();
        
        // TODO: Verify results
        // - Verify that both responses are successful
        // - Null Case
        Map<String,Object> nullResponseMap = (Map<String, Object>) JSON.deserializeUntyped(nullCase.body);
        List<Object> nullMessageList = (List<Object>) nullResponseMap.get('messages');
        Map<String, Object> nullFirstMessage = (Map<String, Object>) nullMessageList[0];

        // - Negative Case
          Map<String,Object> negativeResponseMap = (Map<String, Object>) JSON.deserializeUntyped(negativeCase.body);
        List<Object> negativeMessageList = (List<Object>) negativeResponseMap.get('messages');
        Map<String, Object> negativeFirstMessage = (Map<String, Object>) negativeMessageList[0];


        // - Verify that the service handles these edge cases correctly

        Assert.areEqual(true, nullCase.success, 'Expected null case to succeed, but it has failed');
        Assert.areEqual(true, negativeCase.success, 'Expected negative case to succeed, but it has failed');
        Assert.areEqual(200, nullCase.statusCode, 'Null case - Expected status code 200, actual: ' + nullCase.statusCode);
        Assert.areEqual(200, negativeCase.statusCode, 'Negative case - Expected status code 200, actual: ' + negativeCase.statusCode);
        Assert.areEqual('Sent from your Twilio trial account - Test message from Salesforce 2025-07-29 23:00:27', (String) nullFirstMessage.get('body'), 'Null case - Did not receive the anticipated message body');
        Assert.areEqual('Sent from your Twilio trial account - Test message from Salesforce 2025-07-29 23:00:27', (String) negativeFirstMessage.get('body'), 'Null case - Did not receive the anticipated message body');

    }
    
    /**
     * Test exception handling in makeHttpRequest
     * 
     * TODO: Implement this test method to verify exception handling
     */
    @IsTest
    static void testMakeHttpRequestException() {
        // Test data
        String toNumber = '+5555555555';
        String messageBody = 'Executing testMakeHttpRequestException()';
        
        // TODO: Setup mock that throws exception
        // - Use TwilioCalloutMock.createExceptionMock()
        Test.setMock(HttpCalloutMock.class, new TwilioCalloutMock('Twilio exception has been thrown'));
        
        // TODO: Execute the test
        // - Call a TwilioService method that will use the mock
        Test.startTest();

        TwilioResponse twilioResponse = TwilioService.sendSMS(toNumber, messageBody);

        Test.stopTest();
        
        // TODO: Verify results
        // - Verify that response indicates failure
        // - Verify that status code is set to 500 (or appropriate error code)
        // - Verify that error message is set correctly
        //todo: use getBody as Json method of TwilioResponse class
        Map<String, Object> responseMap = (Map<String,Object>) twilioResponse.getBodyAsJson();
        System.debug(responseMap);
        //Map<String,Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(twilioResponse.body);
        Assert.areEqual(false, twilioResponse.success, 'Expected success to be false, actual: ' + twilioResponse.success);
        Assert.areEqual(500, twilioResponse.statusCode, 'Expected status code 500, actual: ' + twilioResponse.statusCode);
        Assert.areEqual('Twilio exception has been thrown', (String) responseMap.get('error'), 'Expected the following body: "Message body test", actual body: ' + (String) responseMap.get('error'));
       }
} 