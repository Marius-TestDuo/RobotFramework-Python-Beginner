[Documentation]    This test suite test all of the login page functions in a data driven manner.

*** Settings ***
Library    SeleniumLibrary

Resource    ../../resources/locators/loc_login_page.resource
Resource    ../../resources/locators/loc_common.resource
Resource    ../../resources/keywords/kw_common.resource
Resource    ../../resources//keywords/kw_login_page.resource
Test Template    Login With
Test Setup    Start Testing    ${TEST_NAME}    ${True}    2
Test Teardown    Stop Testing
Force Tags    login    regression

*** Variables ***


*** Test Cases ***
Valid Login With Standard User    ${standard_user}    ${standard_password}    ${EMPTY}


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