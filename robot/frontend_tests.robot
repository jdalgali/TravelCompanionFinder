*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${BASE_URL}    http://localhost  # Replace with your app's URL
${EMAIL}       admin@mail.com
${PASSWORD}    admin1234

*** Test Cases ***
Verify Home Page Loads
    Open Browser    ${BASE_URL}    Chrome
    Title Should Be    Travel Companion Finder
    [Teardown]    Close Browser

Login Functionality Test
    Open Browser    ${BASE_URL}    Chrome
    Login To Application    ${EMAIL}    ${PASSWORD}
    Element Should Be Visible    xpath=//h1[text()='Welcome']
    [Teardown]    Close Browser

Navigate to Travel List
    Open Browser    ${BASE_URL}    Chrome
    Login To Application    ${EMAIL}    ${PASSWORD}
    Click Link    xpath=//a[@href='/travel-list']
    Wait Until Page Contains Element    xpath=//h1[text()='Travel List']    10s
    [Teardown]    Close Browser

Create New Travel Entry
    Open Browser    ${BASE_URL}    Chrome
    Login To Application    ${EMAIL}    ${PASSWORD}
    Click Button    xpath=//button[text()='Create New Travel']
    Input Text    xpath=//input[@name='destination']    Paris
    Input Text    xpath=//textarea[@name='description']    Trip to Paris in Spring
    Click Button    xpath=//button[text()='Save']
    Element Should Be Visible    xpath=//div[text()='Travel entry created successfully']
    [Teardown]    Close Browser

Logout Functionality Test
    Open Browser    ${BASE_URL}    Chrome
    Login To Application    ${EMAIL}    ${PASSWORD}
    Click Button    xpath=//button[text()='Logout']
    Element Should Be Visible    xpath=//button[text()='Login']
    [Teardown]    Close Browser

*** Keywords ***
Login To Application
    [Arguments]    ${email}    ${password}
    Go To    ${BASE_URL}
    Wait Until Element Is Visible    xpath=//button[text()='Login']    10s
    Click Element    xpath=//button[text()='Login']
    Input Text    xpath=//input[@name='email']    ${email}
    Input Text    xpath=//input[@name='password']    ${password}
    Click Button    xpath=//button[text()='Submit']
    Wait Until Element Is Visible    xpath=//h1[text()='Welcome']    10s