*** Settings ***
Library           robot.libraries.Collections._List
Library           ExtendedSelenium2Library
Suite Setup       Start Browser
Suite Teardown    Close All Browsers

*** Variables ***
${USERNAME_U}       user
${PWD_U}		    user


*** Keywords ***

Test Config
    Set Selenium Timeout    30
    Set Selenium Speed    0.0s

Start Browser
    [Documentation]   Start browser on Selenium Grid
    Open Browser       ${URL}  ${BROWSER}  Node  http://127.0.0.1:4444/wd/hub
    Set Window Size   1024  768
    Reload Page
    Sleep	2s


*** Test Cases ***
BrowseLinks
    [Documentation]    Browse through the links in ${URL}
    [Setup]    Test Config

    Log 	Browsing to url ${URL}
    Start Browser
    Capture Page Screenshot     browselinks-1.png

    Click Link   Register a new account
    Capture Page Screenshot     browselinks-2.png
# have to reload here because otherwise random failures becasue of stale element
    Reload Page
    Click Link 	 sign in
    Capture Page Screenshot     browselinks-3.png
    Close Browser


*** Test Cases ***
AdminSignIn
    [Documentation]   Sign in as Admin
    [Setup]    Test Config

    Start Browser
    click element  account-menu
    Click Element      login
    Capture Page Screenshot     admin_sign_in-1.png

    Input Text    id=username   ${USERNAME_A}
    Input Text    id=password    ${PWD_A}
    Click Element    xpath=//button[@type='submit']
    Wait Until Element Is Visible    //div[.='You are logged in as user "admin".']
    Capture Page Screenshot     admin_sign_in-2.png
    click element  account-menu
    Click Element  logout
    Capture Page Screenshot     admin_sign_in-3.png
    Close Browser

*** Test Cases ***
RegisterNewAccount
    [Documentation]    Register new account
    [Setup]    Test Config

    Start Browser
    click element   account-menu
    Click Element   register_account

#	Wait Until Element Is Visible    //h1[.='Registration']
    Capture Page Screenshot     register_new_account-1.png
    Input Text  css=input[name='login']    ${USERNAME_TEST}
    Input Text  css=input[name='email']    ${EMAIL}
    Input Text  css=input[name='password']      ${PWD_TEST}
    Input Text  css=input[name='confirmPassword']   ${PWD_TEST}
    Capture Page Screenshot     register_new_account-2.png
    Click Element   xpath=//button[@type='submit']
    Wait Until Element Is Visible   //strong[.='Registration saved!']
    Capture Page Screenshot     register_new_account-3.png
    Close Browser

*** Test Cases ***
CheckMicroservice
    [Documentation]   Sign in as Admin and check that microservice is online
    [Setup]    Test Config

    Start Browser
    click element  account-menu
    Click Element      login
    Capture Page Screenshot     check_microservice-1.png

    Input Text    id=username   ${USERNAME_A}
    Input Text    id=password    ${PWD_A}
    Click Element    xpath=//button[@type='submit']
    Wait Until Element Is Visible    //div[.='You are logged in as user "admin".']
    Capture Page Screenshot     check_microservice-2.png
    click element  admin-menu
    click element   gateway_menu
    Capture Page Screenshot     check_microservice-3.png
    Wait Until Element Is Visible   //td[.='/repository/**']
    Close Browser