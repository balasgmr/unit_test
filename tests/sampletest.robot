*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}    https://demoqa.com

*** Keywords ***
# ---------------------------------------------------------
# Open Browser at Home Page (Headless)
# ---------------------------------------------------------
Open Headless Browser
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --headless
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --disable-gpu
    Create WebDriver    Chrome    options=${options}
    Go To    ${URL}

# ---------------------------------------------------------
# Open Browser To a Specific Page (Headless)
# Example: Open Headless Browser To    /text-box
# ---------------------------------------------------------
Open Headless Browser To
    [Arguments]    ${PATH}
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --headless
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --disable-gpu
    Create WebDriver    Chrome    options=${options}
    Go To    ${URL}${PATH}

*** Test Cases ***

# ---------------------------------------------------------
# 1. Open Home Page
# ---------------------------------------------------------
Open Home Page
    Open Headless Browser
    Title Should Be    DEMOQA
    Close Browser

# ---------------------------------------------------------
# 2. Textbox Form Submission
# ---------------------------------------------------------
Textbox Form Submission
    Open Headless Browser To    /text-box
    Input Text    id:userName           Bala
    Input Text    id:userEmail          bala@example.com
    Input Text    id:currentAddress     Madurai
    Input Text    id:permanentAddress   India
    Click Button  id:submit
    Page Should Contain    Bala
    Close Browser

# ---------------------------------------------------------
# 3. Radio Button Test
# ---------------------------------------------------------
Radio Button Test
    Open Headless Browser To    /radio-button
    Click Element   xpath=//label[text()='Yes']
    Page Should Contain    You have selected Yes
    Close Browser

# ---------------------------------------------------------
# 4. Checkbox Test
# ---------------------------------------------------------
Checkbox Test
    Open Headless Browser To    /checkbox
    Click Element    xpath=//span[@class='rct-checkbox']
    Page Should Contain    You have selected
    Close Browser

# ---------------------------------------------------------
# 5. Dropdown Selection
# ---------------------------------------------------------
Dropdown Selection
    Open Headless Browser To    /select-menu
    Select From List By Label    id:oldSelectMenu    Purple
    List Selection Should Be     id:oldSelectMenu    Purple
    Close Browser
