*** Settings ***
Library     SeleniumLibrary

*** Variables ***
${URL}    https://demoqa.com

*** Keywords ***
Open Headless Chrome
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --headless
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Create WebDriver    Chrome    chrome_options=${options}

*** Test Cases ***
Verify Dropdown And Continue Steps
    Open Headless Chrome
    Go To    ${URL}
    # your steps here
    Close Browser
