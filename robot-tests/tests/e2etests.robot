*** Settings ***
Library           robot.libraries.Collections._List
Library           Selenium2Library
Suite Setup       Start Browser
Suite Teardown    Close Browser

*** Variables ***
${BROWSER}        GoogleChrome
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
    Sleep 2s

#Open Page
#    [Documentation]    Opens browser to login page
#    Open Browser    ${URL}    ${BROWSER}
#    Set Window Size    1024    768
#	Reload Page
#	Sleep    2s


*** Test Cases ***
BrowseLinks
    [Documentation]    Browse through the links in ${URL}
    [Setup]    Test Config

    Log 	Browsing to url ${URL}
    Start Browser

	Click Link   Register a new account
# have to reload here because otherwise random failures becasue of stale element
	Reload Page
	Click Link 	 sign in

#    Input Text    xpath=//input[@id='password']   ${USERNAME_A}
#    Input Text    xpath=//input[@id='password']    ${PWD_A}
#    Click Element    //*[@type='submit']
#	 Wait Until Element Is Visible    //div[.='You are logged in as user "admin".']


*** Test Cases ***
SignInPage
    [Documentation]   Visit sign in page
    [Setup]    Test Config

    Start Browser
	Click Link	sign in

#    Input Text    xpath=//input[@id='password']   ${USERNAME_A}
#    Input Text    xpath=//input[@id='password']    ${PWD_A}
#    Click Element    //*[@type='submit']
#	 Wait Until Element Is Visible    //div[.='You are logged in as user "admin".']

*** Test Cases ***
RegistrationPage
    [Documentation]   Visit registration page 
    [Setup]    Test Config

    Start Browser
	Click Link   Register a new account

#	 Wait Until Element Is Visible    //h1[.='Registration']
