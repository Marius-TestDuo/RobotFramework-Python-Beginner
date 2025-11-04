[Documentation]    This test suite tests all of the login page functions with in-line data.

*** Settings ***
Library    SeleniumLibrary

Resource    ../../../resources/kw_common.resource
Resource    ../../../resources/kw_login_page.resource
Test Template    Login With
Test Setup    Start Testing    ${TEST_NAME}    ${True}    2
Test Teardown    Stop Testing
Force Tags    login    regression

*** Variables ***


*** Test Cases ***
Login - Valid Login With Standard User    ${standard_user}    ${standard_password}    ${EMPTY}
Login - Blank username and password    ${EMPTY}    ${EMPTY}    Epic sadface: Username is required
Login - Blank password    ${standard_user}    ${EMPTY}    Epic sadface: Password is required
Login - Incorrect username, correct password    ThisIsWrong    ${standard_password}    Epic sadface: Username and password do not match any user in this service
Login - Correct username, incorrect password    ${standard_user}    ThisIsWrong    Epic sadface: Username and password do not match any user in this service


*** Keywords ***
Login With
    [Documentation]    Used to test login errors with data driven tests
    [Arguments]    ${username}    ${password}    ${expected_error}
    Wait For Element Visible    ${login_btn}
    Input Text    ${username_txt}    ${username}
    Input Password    ${password_txt}    ${password}
    Click Button    ${login_btn}
    
    IF    '${expected_error}' == '${EMPTY}'
        Wait For Element Visible    ${page_title}
        Log Out
    ELSE
        Wait For Element Visible    ${login_error_message}
        Element Text Should Be      ${login_error_message}    ${expected_error}
        Clear Login Error
    END