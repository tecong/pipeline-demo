*** Settings ***
Library           robot.libraries.Collections._List
Library           Selenium2Library
Suite Setup       Start Browser
Suite Teardown    Close Browser

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
    Capture Page Screenshot     browselinks-{index}.png

    Click Link   Register a new account
    Capture Page Screenshot     browselinks-{index}.png
# have to reload here because otherwise random failures becasue of stale element
    Reload Page
    Click Link 	 sign in
    Capture Page Screenshot     browselinks-{index}.png


*** Test Cases ***
AdminSignIn
    [Documentation]   Sign in as Admin
    [Setup]    Test Config

    Start Browser
    Click Element	id=login
    Capture Page Screenshot     admin_sign_in-{index}.png

    Input Text    id=username   ${USERNAME_A}
    Input Text    id=password    ${PWD_A}
    Click Element    xpath=//button[@type='submit']
    Wait Until Element Is Visible    //div[.='You are logged in as user "admin".']
    Capture Page Screenshot     admin_sign_in-{index}.png
    Click Element  id=logout
    Capture Page Screenshot     admin_sign_in-{index}.png

*** Test Cases ***
RegisterNewAccount
    [Documentation]    Register new account
    [Setup]    Test Config

    Start Browser
    Click Element   id=register_account

	Wait Until Element Is Visible    //h1[.='Registration']
    Capture Page Screenshot     register_new_account-{index}.png
    Input Text  id=login    "robotuser"
    Input Text  id=email    "robotuser@tecdomain.net"
    Input Text  id=password "robotpassu"
    Input Text  id=confirmPassword  "robotpassu"
    Capture Page Screenshot     register_new_account-{index}.png
    Click Element   xpath=//button[@type='submit']
    Wait Until Element Is Visible   //strong[.='Registration saved!']
    Capture Page Screenshot     register_new_account-{index}.png

*** Test Cases ***
LoginWithNewAccount
    [Documentation]  Login with new account
    [Setup]  Test Config

    Start Browser
    Click Element  id=login
    Capture Page Screenshot     login_with_new_account-{index}.png
    Input Text  id=username     "robotuser"
    Input Text  id=password     "robotpassu"
    Click Element   xpath=//button[@type='submit']
    Wait Until Element Is Visible    //div[.='You are logged in as user "robotuser".']
    Capture Page Screenshot     login_with_new_account-{index}.png
    Click Element  id=logout
