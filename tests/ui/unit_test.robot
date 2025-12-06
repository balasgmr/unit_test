*** Settings ***
Library     SeleniumLibrary

*** Variables ***
${URL}    https://demoqa.com/select-menu

*** Keywords ***
Open Headless Chrome
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver

    Call Method    ${options}    add_argument    --headless=new
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --disable-gpu
    Call Method    ${options}    add_argument    --window-size=1920,1080
    Call Method    ${options}    add_argument    --remote-debugging-port=9222

    Create WebDriver    Chrome    options=${options}    executable_path=/usr/bin/chromedriver

*** Test Cases ***
Verify Dropdown And Continue Steps
    Open Headless Chrome
    Go To    ${URL}
    Wait Until Element Is Visible    xpath://select[@id='oldSelectMenu']    10s
    Select From List By Value        xpath://select[@id='oldSelectMenu']    2
    ${selected}=    Get Selected List Label    xpath://select[@id='oldSelectMenu']
    Should Be Equal    ${selected}    Saab
    Close Browser
