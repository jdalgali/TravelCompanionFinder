*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Library    Collections

*** Variables ***
${BASE_URL}    http://localhost:3000
${EMAIL}       admin@mail.com
${PASSWORD}    admin1234
${RECEIVER_ID}    60d0fe4f5311236168a109ca 

*** Keywords ***
Setup
    [Documentation]    Perform login and extract auth token
    Create Session    mysession    ${BASE_URL}
    ${payload}=    Create Dictionary    email=${EMAIL}    password=${PASSWORD}
    ${auth_response}=    POST On Session    mysession    /api/v1/auth/login    json=${payload}
    Log    ${auth_response.status_code}
    Log    ${auth_response.text}
    Should Be Equal As Numbers    ${auth_response.status_code}    200
    ${auth_token}=    Get From Dictionary    ${auth_response.json()}    token
    Set Suite Variable    ${AUTH_TOKEN}    ${auth_token}

*** Test Cases ***
Send Message Test
    [Documentation]    Test sending a message
    [Setup]    Setup
    ${headers}=    Create Dictionary    Authorization=Bearer ${AUTH_TOKEN}    Content-Type=application/json
    ${data}=    Create Dictionary    receiver=${RECEIVER_ID}    content=Hello!
    ${response}=    POST On Session    mysession    /api/v1/messages    headers=${headers}    json=${data}
    Should Be Equal As Numbers    ${response.status_code}    201
    Log    ${response.json()}

Get Messages Test
    [Documentation]    Test fetching messages
    [Setup]    Setup
    ${headers}=    Create Dictionary    Authorization=Bearer ${AUTH_TOKEN}
    ${response}=    GET On Session    mysession    /api/v1/messages    headers=${headers}
    Should Be Equal As Numbers    ${response.status_code}    200
    Log    ${response.json()}

Health Check Test
    [Documentation]    Test the health check endpoint
    ${response}=    GET    ${BASE_URL}/api/v1/health
    Should Be Equal As Numbers    ${response.status_code}    200
    Log    ${response.json()}

Invalid Login Test
    [Documentation]    Test login with invalid credentials
    Create Session    mysession    ${BASE_URL}
    ${payload}=    Create Dictionary    email=invalid@mail.com    password=wrongpassword
    ${response}=    POST On Session    mysession    /api/v1/auth/login    json=${payload}    expected_status=401
    Should Be Equal As Numbers    ${response.status_code}    401
    Log    ${response.json()}

Missing Fields Test
    [Documentation]    Test sending a message with missing fields
    [Setup]    Setup
    ${headers}=    Create Dictionary    Authorization=Bearer ${AUTH_TOKEN}    Content-Type=application/json
    ${data}=    Create Dictionary    content=Hello!
    ${response}=    POST On Session    mysession    /api/v1/messages    headers=${headers}    json=${data}    expected_status=400
    Should Be Equal As Numbers    ${response.status_code}    400
    Log    ${response.json()}