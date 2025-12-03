*** Settings ***
Library    SeleniumLibrary
Suite Setup    Open Headless Chrome
Suite Teardown    Close All Browsers

*** Variables ***
${URL}    https://demoqa.com/select-menu

*** Test Cases ***
Verify Dropdown And Continue Steps
    [Documentation]    Verify selecting a value from dropdown works
    Go To    ${URL}
    Wait Until Element Is Visible    xpath://select[@id='oldSelectMenu']    10s
    Select From List By Value    xpath://select[@id='oldSelectMenu']    2
    ${selected}=    Get Selected List Label    xpath://select[@id='oldSelectMenu']
    Should Be Equal    ${selected}    Saab
