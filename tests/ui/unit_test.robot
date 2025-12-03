*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}    https://example.com

*** Keywords ***
Open Headless Chrome
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --headless=new
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --disable-gpu
    Call Method    ${options}    add_argument    --window-size=1920,1080
    Call Method    ${options}    add_argument    --remote-allow-origins=*

    Create WebDriver    Chrome    options=${options}
    Go To    ${URL}
    Wait Until Page Contains Element    css:body    10s

*** Test Cases ***
Verify Dropdown And Continue Steps
    Open Headless Chrome
    Wait Until Element Is Visible    id:my-select    10s
    Select From List By Label        id:my-select    Two

    ${selected}=    Get Selected List Label    id:my-select
    Should Be Equal    ${selected}    Two

    Wait Until Element Is Visible    css:button    10s
    Click Button    css:button

    Wait Until Page Contains    Received!    10s
    Close Browser
