*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}           https://demoqa.com

# Proper Chromium/Chrome options (each one separate)
${OPTIONS}       add_argument=--headless    add_argument=--no-sandbox    add_argument=--disable-dev-shm-usage    add_argument=--disable-gpu

*** Keywords ***
Open Headless Browser
    Open Browser    ${URL}    chrome    options=${OPTIONS}

*** Test Cases ***

Open Home Page
    Open Headless Browser
    Title Should Be    DEMOQA
    Close Browser

Textbox Form Submission
    Open Browser    ${URL}/text-box    chrome    options=${OPTIONS}
    Input Text    id:userName    Bala
    Input Text    id:userEmail   bala@example.com
    Input Text    id:currentAddress   Madurai
    Input Text    id:permanentAddress India
    Click Button    id:submit
    Page Should Contain    Bala
    Close Browser

Radio Button Test
    Open Browser    ${URL}/radio-button    chrome    options=${OPTIONS}
    Click Element   xpath=//label[text()='Yes']
    Page Should Contain    You have selected Yes
    Close Browser

Checkbox Test
    Open Browser    ${URL}/checkbox    chrome    options=${OPTIONS}
    Click Element    xpath=//span[@class='rct-checkbox']
    Page Should Contain    You have selected
    Close Browser

Dropdown Selection
    Open Browser    ${URL}/select-menu    chrome    options=${OPTIONS}
    Select From List By Label    id:oldSelectMenu    Purple
    List Selection Should Be    id:oldSelectMenu    Purple
    Close Browser
