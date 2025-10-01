[Documentation]
...    This section contains keywords that are reusable and can be utilized across multiple test cases or suites. 
...    Each keyword is designed to perform a specific, commonly needed action, promoting modularity and reducing 
...    code duplication in your Robot Framework test automation.
*** Settings ***
Library    SeleniumLibrary
Library    ScreenCapLibrary
Resource    ../locators/loc_common.resource
Resource    ../locators/loc_login_page.resource
Resource    ../../resources/variables/environment.resource

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
    RETURN    ${opts}

Dismiss Browser Bubble
    [Documentation]    Dismiss browser UI bubbles (e.g., password manager) using ESC.
    Press Keys    None    ESCAPE
    
# -----------------------------------------------------------
#         Setup and Teardown
# -----------------------------------------------------------
Start Testing
    [Documentation]    Used to start a test. Opens the Environment Browser specified "${BROWSER}" and goes to the SUT specified "${SUT}"
    ...    ${test_name} is used to name the video recordings (default = ${TEST_NAME}), 
    ...    ${video} is can be used to record test videos (default = False), 
    ...    ${monitor} is used to indicate which monitor to record (default = 1)
    ...    Start Testing is commonly used with [Setup]
    [Arguments]    ${test_name}=${TEST_NAME}    ${video}=${False}    ${monitor}=1
    # Use Chrome options to disable password/leak prompts when running Chrome
    IF    '${BROWSER}' == 'chrome'
        ${opts}=    Create Chrome Options
        Open Browser    ${SUT}    browser=${BROWSER}    options=${opts}
    ELSE
        Open Browser    ${SUT}    browser=${BROWSER}
    END
    
    # Maximize the browser for maximum realestate
    Maximize Browser Window
    # Set the folder for screenshots
    
    IF    ${video}
        Run Keywords
        ...    SeleniumLibrary.Set Screenshot Directory    ${REPORT_DIR}
        ...    AND
        ...    Start Video Recording    name=${REPORT_DIR}${/}${test_name}    monitor=${monitor}
    ELSE
        SeleniumLibrary.Set Screenshot Directory    ${REPORT_DIR}
    END
    
        
Stop Testing
    [Documentation]    Stops the video recording (if recording = True) and closes all the open browser for the test.
    ...   Commonly used in [Teardown]
    Run Keyword And Ignore Error    Stop Video Recording
    Close All Browsers

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
#         Authentication
# -----------------------------------------------------------
Valid login
    Wait For Element Visible    ${login_btn}
    Input Text    ${username_txt}     ${standard_user}
    Input Password    ${password_txt}    ${standard_password}
    Click Button    ${login_btn}

Log Out
    Wait For Element Visible    ${burger_menu}
    Click Element    ${burger_menu}
    Wait For Element Visible    ${nav_logout}
    Click Element    ${nav_logout}
    Wait For Element Visible    ${login_btn}
    
Confirm Page Title
    [Documentation]   Confirm the expected title of the page
    ...    Usage: Confirm Page Title    title
    [Arguments]    ${title}
    Element Should Contain    ${page_title}    ${title}


# -----------------------------------------------------------
#         Element Keywords
# -----------------------------------------------------------
Element Should Contain Attribute
    [Documentation]   Confirm an attribute of an element
    ...    Usage: Element Should Contain Class    element    attribute    expected
    [Arguments]    ${element}    ${attr}    ${expected}
    Wait For Element Visible    ${element}
    Element Attribute Value Should Be    ${element}    ${attr}    ${expected}

