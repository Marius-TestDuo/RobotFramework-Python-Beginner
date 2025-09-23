*** Settings ***
Library    SeleniumLibrary
Resource    ../locators/login_page.robot


*** Keywords ***

Clear Login Error
    [Documentation]    Used to clear the login errors
    Clear Element Text    ${username_txt}
    Clear Element Text    ${password_txt}
    Click Button    ${login_error_close}
    Wait Until Keyword Succeeds    5    250ms    Element Should Not Be Visible    ${login_error_message}