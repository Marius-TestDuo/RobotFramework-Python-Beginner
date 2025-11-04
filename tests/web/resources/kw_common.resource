[Documentation]
...    This section contains keywords that are reusable and can be utilized across multiple test cases or suites. 
...    Each keyword is designed to perform a specific, commonly needed action, promoting modularity and reducing 
...    code duplication in your Robot Framework test automation.
*** Settings ***
Library    SeleniumLibrary
Library    ScreenCapLibrary
Resource    page_objects/loc_common.resource
Resource    page_objects/loc_login_page.resource
Resource    variables/environment.resource

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

Get Current Page Size
    [Documentation]    Handle responsive layouts driven by CSS media queries.
    ...    Some websites use media queries to display, hide, or re-arrange content depending on viewport size or device features.
    ...    This documentation describes strategies and expectations for automation that must interact reliably with such pages.
    ...    Behavior and purpose
    ...    - Ensure tests interact with the correct visual/layout state produced by media queries.
    ...    - Detect and adapt to element visibility, position, or DOM reflows caused by responsive CSS.
    ...    Recommended approach
    ...    - Set the viewport or emulate the target device before locating or interacting with elements (e.g., set window size or user-agent/device emulation).
    ...    - Wait for layout stabilization after viewport changes or navigation (allowing CSS transitions/animations and reflows to complete).
    ...    - Determine visibility robustly using computed styles and layout properties 
    ...    Return / Outcome
    ...    - Interactions proceed only after the page is in the expected layout state.
    ...    - Raise an explicit error if the expected element cannot be located or is not interactable within the timeout.
    ...    Notes and caveats
    ...    - Avoid relying on absolute coordinates; responsive pages move elements unpredictably across breakpoints.
    ...    - When testing multiple breakpoints, run separate scenarios per viewport rather than trying to handle many breakpoints in a single test step.
    ...    - Be aware of server-side device detection that may also change content in addition to CSS media queries.
    ${width}    ${height}=    Get Window Size
    RETURN    ${width}    ${height}

    
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
        ...    SeleniumLibrary.Set Screenshot Directory    ${RESULT_DIR}
        ...    AND
        ...    Start Video Recording    name=${RESULT_DIR}${/}${test_name}    monitor=${monitor}
    ELSE
        SeleniumLibrary.Set Screenshot Directory    ${RESULT_DIR}
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

