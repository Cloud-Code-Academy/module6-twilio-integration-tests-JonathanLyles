/**
 * TwilioService - Core class for Twilio SMS integration
 * Handles sending and retrieving SMS messages via Twilio API
 */
public with sharing class TwilioService {

    // Constants for Twilio API
    private static final String NAMED_CREDENTIAL = 'TwilioNamedCredential';
    private static String ACCOUNT_SID = '';
    private static String AUTH_TOKEN = '';
    private static String DEFAULT_FROM_NUMBER = '+4444444444';
    private static String TWILIO_API_URL = '';
    
    
    //private static TwilioService instance = null;
    /**
     * Configure Twilio API Settings
     */
    @testVisible
    public static void configure(){

        TwilioApi__c settings = TwilioApi__c.getInstance();
        if(settings == null) {
            return;
        }
        TwilioService.ACCOUNT_SID = settings.ACCOUNT_SID__c;
        TwilioService.AUTH_TOKEN = settings.AUTH_TOKEN__c;
        TwilioService.DEFAULT_FROM_NUMBER = settings.DEFAULT_FROM_NUMBER__c;
        TwilioService.TWILIO_API_URL = settings.TWILIO_API_URL__c;
    }

    
    
    /**
     * Send an SMS message via Twilio
     * @param toNumber - Recipient phone number (E.164 format)
     * @param messageBody - SMS message content
     * @param fromNumber - Optional sender phone number (defaults to DEFAULT_FROM_NUMBER)
     * @return TwilioResponse containing status and message details
     */
    public static TwilioResponse sendSMS(String toNumber, String messageBody) {

        configure();
        
        // Prepare request parameters
        Map<String, String> params = new Map<String, String> {
            'To' => toNumber,
            'From' => DEFAULT_FROM_NUMBER,
            'Body' => messageBody
        };
        
        System.debug(params);

        HttpResponse response = makeHttpRequest('POST', '/Messages.json', params);
        return parseResponse(response);
    }
    
    /**
     * Retrieve SMS messages from Twilio
     * @param limit - Maximum number of messages to retrieve (default: 20)
     * @return TwilioResponse containing status and list of messages
     */
    public static TwilioResponse getMessages(Integer pageLimit) {

        configure();

        if (pageLimit == null || pageLimit <= 0) {
            pageLimit = 20;
        }
        
        Map<String, String> params = new Map<String, String> {
            'PageSize' => String.valueOf(pageLimit)
        };
        
        HttpResponse response = makeHttpRequest('GET', '/Messages.json', params);
        return parseResponse(response);
    }
    
    /**
     * Common method to make HTTP requests to Twilio API
     */
    private static HttpResponse makeHttpRequest(String method, String endpoint, Map<String, String> params) {

        configure();

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:' + NAMED_CREDENTIAL + '/' + TWILIO_API_URL + endpoint);
        request.setMethod(method);
        
        //Add Basic Auth header for Twilio authentication
        //Twilio uses HTTP Basic Auth with Account SID as username and Auth Token as password

        // String authString = ACCOUNT_SID + ':' + AUTH_TOKEN;
        // Blob headerValue = Blob.valueOf(authString);
        // String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        // request.setHeader('Authorization', authorizationHeader);
        
        // Set timeout to avoid long-running callouts
        request.setTimeout(20000); // 20 seconds timeout
        
        // Add parameters to request
        if (method == 'GET') {
            String queryParams = '';
            for (String key : params.keySet()) {
                if (queryParams != '') {
                    queryParams += '&';
                }
                queryParams += key + '=' + EncodingUtil.urlEncode(params.get(key), 'UTF-8');
            }
            if (queryParams != '') {
                String endpoint1 = request.getEndpoint();
                request.setEndpoint(endpoint1 + '?' + queryParams);
            }
        } else {
            // For POST and PUT requests, use form URL encoded format
            request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            String requestBody = '';
            for (String key : params.keySet()) {
                if (requestBody != '') {
                    requestBody += '&';
                }
                requestBody += key + '=' + EncodingUtil.urlEncode(params.get(key), 'UTF-8');
            }
            request.setBody(requestBody);
        }

   
        
        try {
            System.debug('Sending request to: ' + request.getEndpoint());
            System.debug('With method: ' + method);
            if (method != 'GET') {
                System.debug('Request body: ' + request.getBody());
            }
            
            HttpResponse response = http.send(request);
            System.debug('Response status code: ' + response.getStatusCode());
            System.debug('Response body: ' + response.getBody());
            
            return response;
        } catch (Exception e) {
            System.debug('Error making HTTP request: ' + e.getMessage());
            // Handle exceptions
            HttpResponse errorResponse = new HttpResponse();
            errorResponse.setStatusCode(500);
            errorResponse.setBody('{"error": "' + e.getMessage() + '"}');
            System.debug(errorResponse.getBody());
            return errorResponse;
        }
    }
    
    /**
     * Parse HTTP response from Twilio
     */
    private static TwilioResponse parseResponse(HttpResponse response) {
        TwilioResponse twilioResponse = new TwilioResponse();
        twilioResponse.statusCode = response.getStatusCode();
        twilioResponse.body = response.getBody();
        twilioResponse.success = (response.getStatusCode() >= 200 && response.getStatusCode() < 300);
        
        return twilioResponse;
    }
}