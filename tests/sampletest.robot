*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}    https://demoqa.com

*** Keywords ***
Open Headless Browser
    ${options}=    Create List    --headless    --no-sandbox    --disable-dev-shm-usage    --disable-gpu
    Create Webdriver    Chrome    options=${options}
    Go To    ${URL}

Open Headless Browser To    ${path}
    ${options}=    Create List    --headless    --no-sandbox    --disable-dev-shm-usage    --disable-gpu
    Create Webdriver    Chrome    options=${options}
    Go To    ${URL}${path}

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
