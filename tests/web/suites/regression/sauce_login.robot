*** Settings ***
Resource    ../../resources/locators/login_page.robot
Resource    ../../resources/locators/common_locators.robot
Resource    ../../resources/keywords/common_keywords.robot

*** Variables ***


*** Test Cases ***
Standard User - Valid Login
    [Documentation]    Test the standard user login with a valid login
    [Tags]    login
    [Setup]    Start Testing    ${TEST NAME}    ${True}    2
    [Teardown]    Stop Testing

    # Login
    Valid login
    
    # Confirm user is logged in 
    Wait For Element Visible    ${page_title}

Login Error Checks
    [Documentation]    Test the standard user login with a valid login
    [Tags]    login
    [Setup]    Start Testing    ${TEST NAME}    ${True}    2
    [Teardown]    Stop Testing



Locaked Out User
    [Documentation]    Test the locked out user login
    [Tags]    login
    [Setup]    Start Testing    ${TEST NAME}
    [Teardown]    Stop Testing

    # Login
    Wait For Element Visible    ${login_btn}
    Input Text    ${username_txt}     ${locked_out_user}
    Input Password    ${password_txt}    ${standard_password}
    Click Button    ${login_btn}
    
    # Confirm error
    Wait For Element Visible    ${login_error_message}
    Element Text Should Be    ${login_error_message}    Epic sadface: Sorry, this user has been locked out.
    Element Should Contain Attribute    ${username_txt}    class    input_error form_input error
    Element Should Contain Attribute    ${password_txt}    class    input_error form_input error