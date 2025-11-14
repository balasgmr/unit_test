*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}    https://demoqa.com

*** Keywords ***
Open Headless Browser
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --headless
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --disable-gpu
    Create WebDriver    Chrome    options=${options}
    Go To    ${URL}

Open Headless Browser To    ${PATH}
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --headless
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --disable-gpu
    Create WebDriver    Chrome    options=${options}
    Go To    ${URL}${PATH}

*** Test Cases ***
Open Home Page
    Open Headless Browser
    Title Should Be    DEMOQA
    Close Browser

Textbox Form Submission
    Open Headless Browser To    /text-box
    Input Text    id:userName    Bala
    Input Text    id:userEmail   bala@example.com
    Input Text    id:currentAddress   Madurai
    Input Text    id:permanentAddress India
    Click Button    id:submit
    Page Should Contain    Bala
    Close Browser

Radio Button Test
    Open Headless Browser To    /radio-button
    Click Element   xpath=//label[text()='Yes']
    Page Should Contain    You have selected Yes
    Close Browser

Checkbox Test
    Open Headless Browser To    /checkbox
    Click Element    xpath=//span[@class='rct-checkbox']
    Page Should Contain    You have selected
    Close Browser

Dropdown Selection
    Open Headless Browser To    /select-menu
    Select From List By Label    id:oldSelectMenu    Purple
    List Selection Should Be    id:oldSelectMenu    Purple
    Close Browser
