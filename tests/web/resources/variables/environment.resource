*** Variables ***
${SUT}=    https://www.saucedemo.com
${BROWSER}=    chrome

${LONG_WAIT}=    30s
${SHORT_WAIT}=    5s
${POLL_INTERVAL}=    500ms
${RESULT_DIR}=    ${OUTPUT DIR}

${standard_user}=    standard_user
${locked_out_user}=    locked_out_user
${problem_user}=    problem_user
${performance_glitch_user}=    performance_glitch_user
${error_user}=    error_user
${visual_user}=    visual_user

${standard_password}=    secret_sauce

