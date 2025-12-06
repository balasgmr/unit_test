*** Settings ***
Library     SeleniumLibrary

*** Variables ***
${URL}    https://demoqa.com

*** Keywords ***
Open Headless Chrome
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --headless=new
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --remote-debugging-port=9222
    Call Method    ${options}    add_argument    --disable-gpu

    Create WebDriver    Chrome    options=${options}    executable_path=/usr/bin/chromedriver

*** Test Cases ***
Verify Dropdown And Continue Steps
    Open Headless Chrome
    Go To    ${URL}
    Close Browser
