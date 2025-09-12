[Documentation]
...    This section contains keywords that are reusable and can be utilized across multiple test cases or suites. 
...    Each keyword is designed to perform a specific, commonly needed action, promoting modularity and reducing 
...    code duplication in your Robot Framework test automation.
*** Settings ***
Library    SeleniumLibrary
Resource    ../locators/login_page.robot
Resource    ../locators/common_locators.robot
Resource    ../../resources/variables/environment.robot

*** Keywords ***
# -----------------------------------------------------------
#         Browser Options Helpers
# -----------------------------------------------------------
Create Chrome Options
    [Documentation]    Build Chrome options that disable password UI and breach warnings.
    ${opts}=    Evaluate    __import__('selenium.webdriver.chrome.options', fromlist=['Options']).Options()
    &{prefs}=    Create Dictionary    credentials_enable_service=${False}    profile.password_manager_enabled=${False}    password_manager_leak_detection_enabled=${False}
    Call Method    ${opts}    add_experimental_option    prefs    ${prefs}
    Call Method    ${opts}    add_argument    --no-first-run
    Call Method    ${opts}    add_argument    --no-default-browser-check
    Call Method    ${opts}    add_argument    --incognito
    ${disable_features}=    Set Variable    --disable-features=PasswordLeakDetection,PasswordManagerOnboarding,AutofillEnableAccountStorage
    Call Method    ${opts}    add_argument    ${disable_features}
    [Return]    ${opts}

# -----------------------------------------------------------
#         UI Bubble Fallbacks
# -----------------------------------------------------------
Dismiss Browser Bubble
    [Documentation]    Dismiss browser UI bubbles (e.g., password manager) using ESC.
    Press Keys    None    ESCAPE
    
# -----------------------------------------------------------
#         Setup and Teardown
# -----------------------------------------------------------
Start Testing
    [Documentation]    Used to start a test. Opens the Environment Browser specified "${BROWSER}" and goes to the SUT specified "${SUT}"
    ...    Used with test Setup
    [Arguments]    ${test_name}
    Log    Starting test ${test_name}
    # Use Chrome options to disable password/leak prompts when running Chrome
    IF    '${BROWSER}' == 'chrome'
        ${opts}=    Create Chrome Options
        Open Browser    ${SUT}    browser=${BROWSER}    options=${opts}
    ELSE
        Open Browser    ${SUT}    browser=${BROWSER}
    END

# -----------------------------------------------------------
#         Custom Waits
# -----------------------------------------------------------
Wait For Element Visible
    [Documentation]    Wait X amount of seconds for an element to be visible. Polling the DOM every ${POLL_INTERVAL}.
    ...    If no timeout is passed the global  timeout of ${LONG_WAIT} will be applied
    ...    Usage: Wait For Element Visible    element    timeout
    [Arguments]    ${element}    ${time_out}=${LONG_WAIT}
    Wait Until Keyword Succeeds    ${time_out}     ${POLL_INTERVAL}     Element Should Be Visible     ${element}



# -----------------------------------------------------------
#         Login Page
# -----------------------------------------------------------
Valid login
    Wait For Element Visible    ${login_btn}
    Input Text    ${username_txt}     ${standard_user}
    Input Password    ${password_txt}    ${standard_password}
    Click Button    ${login_btn}
    
Confrim Page Title
    [Documentation]   Confirm the expected title of the page
    ...    Usage: Confrim Page Title    title
    [Arguments]    ${title}
    Element Should Contain    ${page_title}    ${title}
