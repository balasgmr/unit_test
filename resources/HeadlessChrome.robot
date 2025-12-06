*** Keywords ***
Open Headless Chrome
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --headless
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --window-size=1920,1080

    ${chrome_path}=    Evaluate    __import__('webdriver_manager.chrome').ChromeDriverManager().install()    webdriver_manager.chrome
    Create WebDriver    Chrome    options=${options}    executable_path=${chrome_path}    service_log_path=./chromedriver.log
