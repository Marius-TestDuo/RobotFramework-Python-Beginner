[Documentation]    This test suite tests all of the login page functions in a classical manner.

*** Settings ***
Library    SeleniumLibrary
Resource    ../../../resources/kw_common.resource
Resource    ../../../resources/kw_login_page.resource

*** Variables ***


*** Test Cases ***
Login - Valid Login With Standard User
    [Documentation]    Test the standard user login with a valid login
    [Tags]    order    valid user regression    shop    cart    priority1
    [Setup]    Start Testing    ${TEST NAME}    ${True}    2
    [Teardown]    Stop Testing
    # Login
    Valid login
    # Confirm user is logged in 
    Wait For Element Visible    ${page_title}













    
    Log Out

