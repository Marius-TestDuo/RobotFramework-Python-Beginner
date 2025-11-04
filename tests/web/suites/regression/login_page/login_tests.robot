[Documentation]    This test suite tests all of the login page functions in a classical manner.

*** Settings ***
Library    SeleniumLibrary
Resource    ../../../resources/kw_common.resource
Resource    ../../../resources/kw_login_page.resource

*** Variables ***


*** Test Cases ***
Login - Valid Login With Standard User
    [Documentation]    Test the standard user login with a valid login
    [Tags]    login    valid    regression
    [Setup]    Start Testing    ${TEST NAME}    ${True}    2
    [Teardown]    Stop Testing
    # Login
    Valid login
    # Confirm user is logged in 
    Wait For Element Visible    ${page_title}
    Log Out

Login - Login Error Checks
    [Documentation]    Test all errors on the login form
    [Tags]    login    invalid    regression
    [Setup]    Start Testing    ${TEST NAME}    ${True}    2
    [Teardown]    Stop Testing

    Log    Blank username and password
    Wait For Element Visible    ${login_btn}
    Input Text    ${username_txt}    ${EMPTY}
    Input Password    ${password_txt}    ${EMPTY}
    Click Button    ${login_btn}
    Wait For Element Visible    ${login_error_message}
    Element Should Contain Attribute    ${username_txt}    class    input_error form_input error
    Element Should Contain Attribute    ${password_txt}    class    input_error form_input error
    Element Text Should Be    ${login_error_message}     Epic sadface: Username is required
    Clear Login Error

    Log    Blank password
    Input Text    ${username_txt}    ${standard_user}
    Input Password    ${password_txt}    ${EMPTY}
    Click Button    ${login_btn}
    Wait For Element Visible    ${login_error_message}
    Element Should Contain Attribute    ${username_txt}    class    input_error form_input error
    Element Should Contain Attribute    ${password_txt}    class    input_error form_input error
    Element Text Should Be    ${login_error_message}     Epic sadface: Password is required
    Clear Login Error

    Log    Incorrect username, correct password
    Input Text    ${username_txt}    incorrect
    Input Password    ${password_txt}    ${standard_password}
    Click Button    ${login_btn}
    Wait For Element Visible    ${login_error_message}
    Element Should Contain Attribute    ${username_txt}    class    input_error form_input error
    Element Should Contain Attribute    ${password_txt}    class    input_error form_input error
    Element Text Should Be    ${login_error_message}     Epic sadface: Username and password do not match any user in this service
    Clear Login Error

    Log    Correct username, incorrect password
    Input Text    ${username_txt}    ${standard_user}
    Input Password    ${password_txt}    ButWhy
    Click Button    ${login_btn}
    Wait For Element Visible    ${login_error_message}
    Element Should Contain Attribute    ${username_txt}    class    input_error form_input error
    Element Should Contain Attribute    ${password_txt}    class    input_error form_input error
    Element Text Should Be    ${login_error_message}     Epic sadface: Username and password do not match any user in this service

Login - Locked Out User
    [Documentation]    Test the locked out user to confirm they are not able to login
    [Tags]    login
    [Setup]    Start Testing    ${TEST NAME}
    [Teardown]    Stop Testing

    Log    Login with locked out user
    Wait For Element Visible    ${login_btn}
    Input Text    ${username_txt}     ${locked_out_user}
    Input Password    ${password_txt}    ${standard_password}
    Click Button    ${login_btn}
    
    Log    Confirm the error message
    Wait For Element Visible    ${login_error_message}
    Element Text Should Be    ${login_error_message}    Epic sadface: Sorry, this user has been locked out.
    Element Should Contain Attribute    ${username_txt}    class    input_error form_input error
    Element Should Contain Attribute    ${password_txt}    class    input_error form_input error
    Clear Login Error