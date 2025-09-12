*** Settings ***
Resource    ../../resources/locators/login_page.robot
Resource    ../../resources/locators/common_locators.robot
Resource    ../../resources/keywords/common_keywords.robot

*** Variables ***


*** Test Cases ***
Standard User Login
    [Documentation]
    [Tags]
    [Setup]    Start Testing    ${TEST NAME}

    Valid login
    Wait For Element Visible    ${page_title}