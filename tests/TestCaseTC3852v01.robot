*** Settings ***

Library    RequestsLibrary
Library    Collections
Library    OperatingSystem
Library    SeleniumLibrary
Library    DateTime
Library    BuiltIn



*** Variables ***

${MyHostname}    demo6733
${MyRepositoryName}    TMPWEBV497TC3852
# You must create the folder "MyFolderWorkspace" manually in the computer of Jenkins master, in case you test the script with the computer of Jenkins master
${MyFolderWorkspace}    C:/000/jenkins/workspace
${MyDirectoryDownload}    C:\\temp\\zDownload
${base_url_smtp_server}    http://localhost:8070

${MyPatient1FamilyName}    AZ127431
${MyPatient1FirstName}    ALBERT
${MyPatient1SeriesDescription}    CTOP127431
${MyPatient1BirthdateYYYY}    1945
${MyPatient1BirthdateMM}    11
${MyPatient1BirthdateDD}    27
${MyPatient1AccessionNumber}    CTEF127431

${MyPatient2FamilyName}    AZ138542
${MyPatient2FirstName}    ALBERT
${MyPatient2SeriesDescription}    CTOP138542
${MyPatient2BirthdateYYYY}    1956
${MyPatient2BirthdateMM}    12
${MyPatient2BirthdateDD}    28
${MyPatient2AccessionNumber}    CTEF138542

${MyPatient3FamilyName}    AZ250764
${MyPatient3FirstName}    BERNARD
${MyPatient3SeriesDescription}    CTOP250764
${MyPatient3BirthdateYYYY}    1958
${MyPatient3BirthdateMM}    11
${MyPatient3BirthdateDD}    30
${MyPatient3AccessionNumber}    CTEF250764

${MyPatient4FamilyName}    AZ149653
${MyPatient4FirstName}    ALBERT
${MyPatient4SeriesDescription}    CTOP149653
${MyPatient4BirthdateYYYY}    1967
${MyPatient4BirthdateMM}    10
${MyPatient4BirthdateDD}    29
${MyPatient4AccessionNumber}    CTEF149653

${MyPatient5FamilyName}    AZ361875
${MyPatient5FirstName}    DIDIER
${MyPatient5SeriesDescription}    CTOP361875
${MyPatient5BirthdateYYYY}    1969
${MyPatient5BirthdateMM}    12
${MyPatient5BirthdateDD}    13
${MyPatient5AccessionNumber}    CTEF361875

${MyPortNumber}    10000
#  Do not use the brackets to define the variable of bearer token
${bearerToken}    Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJJbnN0YWxsZXIiLCJuYW1lIjoiSW5zdGFsbGVyIiwiaXNzIjoiVGVsZW1pcyIsImlhdCI6MTUxNjIzOTAyMiwiZXhwIjoxODYxOTIwMDAwfQ.pynnZ69Qx50wuz0Gh4lx-FHZznrcQkbMm0o-PLhb3S0

${MyBrowser1}    chrome
${MyBrowser2}    firefox
${MyBrowser3}    edge

${TmpWebAdministratorLogin}    telemis_webadmin
${TmpWebAdministratorPassword}    KEYCLOAKTastouk!

${TmpWebUser1Login}    anthony
${TmpWebUser1Password}    Videogames2024
${TmpWebUser1Email}    anthony@hospital8.com

${TmpWebUser2Login}    albert
${TmpWebUser2Password}    Videogames2024
${TmpWebUser2Email}    albert@hospital8.com

${TmpWebUser3Login}    mary
${TmpWebUser3Password}    Videogames2024
${TmpWebUser3Email}    mary@hospital8.com

${TmpWebUser4Login}    thomas
${TmpWebUser4Password}    Videogames2024
${TmpWebUser4Email}    thomas@hospital8.com

# NOT USEFUL ${MyFolderResults}    results
${MyLogFile}    MyLogFile.log
${MyFolderCertificate}    security
${MyDicomPath}    C:/VER497TMP1/telemis/dicom

${MyEntityName1}    audit
${MyEntityPort1}    9940
${MyEntityName2}    dicomgate
${MyEntityPort2}    9920
${MyEntityName3}    hl7gate
${MyEntityPort3}    9930
${MyEntityName4}    patient
${MyEntityPort4}    9990
${MyEntityName5}    registry
${MyEntityPort5}    9960
${MyEntityName6}    repository
${MyEntityPort6}    9970
${MyEntityName7}    user
${MyEntityPort7}    9950
${MyEntityName8}    worklist
${MyEntityPort8}    9980

${VersionSiteManager}    4.1.2-228



*** Keywords ***

Remove The Previous Results
    [Documentation]    Delete the previous results and log files
    Remove Files    ${MyFolderWorkspace}/${MyRepositoryName}/results/geckodriver*
    # Delete the previous screenshots
    Remove Files    ${MyFolderWorkspace}/${MyRepositoryName}/results/*.png
    Remove Files    ${MyFolderWorkspace}/${MyRepositoryName}/results/${MyLogFile}
    ${Time} =    Get Current Date
    Create file  ${MyFolderWorkspace}/${MyRepositoryName}/results/${MyLogFile}    ${Time}${SPACE}Start the tests \n
    # Remove DICOM files from dicomPath of TMAA
    Remove Files    ${MyDicomPath}/*.dcm


Check That Watchdog Is Running
    [Documentation]    Check that Watchdog is running
    create session    mysession    https://${MyHostname}:${MyPortNumber}/watchdog/api/admin

    ${headers}    create dictionary    Authorization=${bearerToken}

    ${response} =    GET On Session    mysession    /ping    headers=${headers}    verify=${MyFolderWorkspace}/${MyRepositoryName}/tests/${MyFolderCertificate}/telemis_ca.cer
    log    ${response.status_code}
    log    ${response.content}

    Should Be Equal As Strings    ${response.status_code}    200
    Sleep    3s


Check Version Of Watchdog
    [Documentation]    Check the version number of Watchdog
    create session    mysession    https://${MyHostname}:${MyPortNumber}/watchdog/api/admin

    ${headers}    create dictionary    Authorization=${bearerToken}

    ${response} =    GET On Session    mysession    /version    headers=${headers}    verify=${MyFolderWorkspace}/${MyRepositoryName}/tests/${MyFolderCertificate}/telemis_ca.cer
    log    ${response.status_code}
    log    ${response.content}
    ${Time} =    Get Current Date
    Append To File    ${MyLogFile}    ${Time}${SPACE}Version number of Watchdog ${response.text} \n

    Should Be Equal As Strings    ${response.status_code}    200
    Sleep    3s
    # Should Contain    ${response.text}    ${VersionSiteManager}


Check That Site Manager Is Running
    [Documentation]    Check that Site Manager is running
    create session    mysession    https://${MyHostname}:${MyPortNumber}/site/api/admin

    ${headers}    create dictionary    Authorization=${bearerToken}

    ${response} =    GET On Session    mysession    /ping    headers=${headers}    verify=${MyFolderWorkspace}/${MyRepositoryName}/tests/${MyFolderCertificate}/telemis_ca.cer
    log    ${response.status_code}
    log    ${response.content}

    Should Be Equal As Strings    ${response.status_code}    200
    Sleep    3s


Check Version Of Site Manager
    [Documentation]    Check the version number of Site Manager
    create session    mysession    https://${MyHostname}:${MyPortNumber}/site/api/admin

    ${headers}    create dictionary    Authorization=${bearerToken}

    ${response} =    GET On Session    mysession    /version    headers=${headers}    verify=${MyFolderWorkspace}/${MyRepositoryName}/tests/${MyFolderCertificate}/telemis_ca.cer
    log    ${response.status_code}
    log    ${response.content}
    ${Time} =    Get Current Date
    Append To File    ${MyLogFile}    ${Time}${SPACE}Version number of Site Manager ${response.text} \n

    Should Be Equal As Strings    ${response.status_code}    200
    Sleep    2s

    ${response} =    GET On Session    mysession    /identity    headers=${headers}    verify=${MyFolderWorkspace}/${MyRepositoryName}/tests/${MyFolderCertificate}/telemis_ca.cer
    log    ${response.status_code}
    log    ${response.content}
    Should Be Equal As Strings    ${response.status_code}    200
    Should Contain    ${response.text}    sitemanager
    Sleep    3s


Check That Telemis Entity Is Running
    [Documentation]    Check that Telemis Entity is running
    [Arguments]    ${MyEntityPort}
    create session    mysession    https://${MyHostname}:${MyEntityPort}/api/admin

    ${headers}    create dictionary    Authorization=${bearerToken}

    ${response} =    GET On Session    mysession    /ping    headers=${headers}    verify=${MyFolderWorkspace}/${MyRepositoryName}/tests/${MyFolderCertificate}/telemis_ca.cer
    log    ${response.status_code}
    log    ${response.content}

    Should Be Equal As Strings    ${response.status_code}    200
    Sleep    3s


Check Version Of Telemis Entity
    [Documentation]    Check the version number of entity
    [Arguments]    ${MyEntityName}    ${MyEntityPort}
    create session    mysession    https://${MyHostname}:${MyEntityPort}/api/admin

    ${headers}    create dictionary    Authorization=${bearerToken}

    ${response} =    GET On Session    mysession    /version    headers=${headers}    verify=${MyFolderWorkspace}/${MyRepositoryName}/tests/${MyFolderCertificate}/telemis_ca.cer
    log    ${response.status_code}
    log    ${response.content}
    ${Time} =    Get Current Date
    Append To File    ${MyLogFile}    ${Time}${SPACE}Version number of Telemis-${MyEntityName}${SPACE}${response.text} \n

    Should Be Equal As Strings    ${response.status_code}    200
    Sleep    2s

    ${response} =    GET On Session    mysession    /identity    headers=${headers}    verify=${MyFolderWorkspace}/${MyRepositoryName}/tests/${MyFolderCertificate}/telemis_ca.cer
    log    ${response.status_code}
    log    ${response.content}
    Should Be Equal As Strings    ${response.status_code}    200
    Should Contain    ${response.text}    ${MyEntityName}
    Sleep    3s


Take My Screenshot
    ${MyCurrentDateTime} =    Get Current Date    result_format=%Y%m%d%H%M%S
    Log    ${MyCurrentDateTime}
    # Keyword of SeleniumLibrary, you do not need to use the library Screenshot
    Capture Page Screenshot    selenium-screenshot-${MyCurrentDateTime}.png
    Sleep    2s


Open My Site Manager
    Open Browser    https://${MyHostname}:10000/site    Chrome    options=add_argument("--disable-infobars");add_argument("--lang\=en");binary_location=r"C:\\000\\chromeWin64ForTests\\chrome.exe"
    Wait Until Element Is Visible    id=kc-login    timeout=15s
    Maximize Browser Window
    Sleep    2s
    Input Text    id=username    local_admin    clear=True
    Input Text    id=password    KEYCLOAKTastouk!    clear=True
    Sleep    2s
    Click Button    id=kc-login
    # Locator of Selenium IDE
    Wait Until Element Is Visible    xpath=//strong[contains(.,'Site Manager')]    timeout=15s
    Element Should Be Visible    xpath=//strong[contains(.,'Site Manager')]
    Sleep    2s


Log Out My User Session Of Site Manager
    Click Link    link:Sign out
    Wait Until Element Is Visible    id=kc-login    timeout=15s
    Element Should Be Visible    id=kc-login
    Sleep    2s


My User Opens Internet Browser And Connects To My TMP Web
    [Documentation]    The user opens Internet browser and then connects to the website of TMP Web
    [Arguments]    ${MyUserLogin}    ${MyUserPassword}
    Open Browser    https://${MyHostname}.telemiscloud.com/tmpweb/patients.app    Chrome    options=add_argument("--disable-infobars");add_argument("--lang\=en");binary_location=r"C:\\000\\chromeWin64ForTests\\chrome.exe"
    Wait Until Page Contains    TM-Publisher web    timeout=15s
    Maximize Browser Window
    Wait Until Element Is Visible    id=username    timeout=15s
    Wait Until Element Is Visible    id=password    timeout=15s
    Input Text    id=username    ${MyUserLogin}    clear=True
    Wait Until Keyword Succeeds    15s    3s    Textfield Value Should Be    id=username    ${MyUserLogin}
    Input Text    id=password    ${MyUserPassword}    clear=True
    Wait Until Keyword Succeeds    15s    3s    Textfield Value Should Be    id=password    ${MyUserPassword}
    Click Button    id=kc-login
    Wait Until Page Contains    Telemis Media Publisher Web    timeout=15s
    Sleep    3s


Log Out My User Session Of TMP Web
    Click Link    link=Logout
    Wait Until Element Is Visible    xpath=//*[@id="doctor-button"]    timeout=15s
    Sleep    2s


Delete All My Email Messages In SMTP Server
    [Documentation]    Delete all the email messages in SMTP server
    Create Session    AppAccess    ${base_url_smtp_server}
    ${response} =    Delete On Session    AppAccess    /api/emails
    log    ${response.status_code}
    log    ${response.content}
    Should Be Equal As Strings    ${response.status_code}    200
    Sleep    2s



*** Test Cases ***

Test01
    [Documentation]    Reset the test results
    [Tags]    CRITICALITY LOW
    Remove Files    ${MyFolderWorkspace}/${MyRepositoryName}/results/*.png


Test02
    [Documentation]    Test and check SMTP server
    [Tags]    CRITICALITY LOW
    Open Browser    http://localhost:8070/    Chrome    options=add_argument("--disable-infobars");add_argument("--lang\=en");binary_location=r"C:\\000\\chromeWin64ForTests\\chrome.exe"
    Maximize Browser Window
    Wait Until Page Contains    FakeSMTPServer    timeout=15s
    Wait Until Page Contains    Inbox    timeout=15s


Test03
    [Documentation]    Reset the list of email messages in SMTP server
    [Tags]    CRITICALITY LOW
    Delete All My Email Messages In SMTP Server
    Sleep    2s
    Go To    http://localhost:8070/
    Sleep    1s
    Close All Browsers


Test04
    [Documentation]    Administrator connects to the website of TMP Web
    [Tags]    CRITICALITY NORMAL
    My User Opens Internet Browser And Connects To My TMP Web    ${TmpWebAdministratorLogin}    ${TmpWebAdministratorPassword}


Test05
    [Documentation]    Select the language
    [Tags]    CRITICALITY LOW
    Wait Until Element Is Visible    id=languageSelect    timeout=15s
    Select From List By Label    id=languageSelect    English
    Wait Until Element Is Visible    id=searchInput    timeout=15s
    Click Element    id=searchInput


Test06
    [Documentation]    Select and open the option "Manage disk space"
    [Tags]    CRITICALITY NORMAL
    Wait Until Page Contains    Admin    timeout=15s
    Wait Until Element Is Visible    link=Admin    timeout=15s
    Click Link    link=Admin
    Wait Until Page Contains    Manage disk space    timeout=15s
    Wait Until Element Is Visible    link=Manage disk space    timeout=15s
    Click Link    link=Manage disk space


Test07
    [Documentation]    Check the items of the page "Manage disk space" are valid
    [Tags]    CRITICALITY HIGH
    # Section 1 (Repository Stats)
    Wait Until Page Contains    Repository Stats    timeout=15s
    Wait Until Page Contains    Disk Free space    timeout=15s
    Wait Until Page Contains    Disk Total space    timeout=15s
    Wait Until Page Contains    Disk Occupation rate    timeout=15s
    # Section 2 (Query size for unused data)
    Wait Until Page Contains    Query size for unused data    timeout=15s
    Wait Until Page Contains    Accession not seen for    timeout=15s
    Wait Until Element Is Visible    id=consultationDelay    timeout=15s
    Wait Until Page Contains    and with an acquisition date older than    timeout=15s
    Wait Until Element Is Visible    id=aquisitionDelay    timeout=15s
    Wait Until Page Contains    and with a publication date older than    timeout=15s
    Wait Until Element Is Visible    id=publicationDelay    timeout=15s
    Wait Until Page Contains    left blank to ignore this criteria    timeout=15s
    # Locator of the button "Compute", the keyword (Wait Until Page Contains) does NOT detect the text "Compute"
    Wait Until Element Is Visible    name=query    timeout=15s
    Wait Until Page Contains    Number of studies    timeout=15s
    Wait Until Page Contains    Approx. size of selected data    timeout=15s
    # Locator of the button "View selection", the keyword (Wait Until Page Contains) does NOT detect the text "View selection"
    Wait Until Element Is Visible    name=log    timeout=15s
    # Section 3 (Perform clean-up)
    Wait Until Page Contains    Perform clean-up    timeout=15s
    Wait Until Page Contains    You can perform a clean up of the repository    timeout=15s
    Wait Until Element Is Visible    name=delete    timeout=15s


Test08
    [Documentation]    Modify and configure the fields "Date of access", "Date of acquition" and "Date of publication"
    [Tags]    CRITICALITY HIGH
    Element Should Be Visible    id=consultationDelay
    Clear element Text    id=consultationDelay
    Sleep    1s
    ${MyValue} =    Get Text    id=consultationDelay
    Should Be Empty    ${MyValue}

    Element Should Be Visible    id=aquisitionDelay
    Input Text    id=aquisitionDelay    999    clear=True
    Wait Until Keyword Succeeds    15s    3s    Textfield Value Should Be    id=aquisitionDelay    999

    Element Should Be Visible    id=publicationDelay
    Clear element Text    id=publicationDelay
    Sleep    1s
    ${MyValue} =    Get Text    id=publicationDelay
    Should Be Empty    ${MyValue}


Test09
    [Documentation]    Click the button "Compute" and then check the number of selected studies that will be deleted in the repository
    [Tags]    CRITICALITY NORMAL
    Element Should Be Visible    name=query
    Click Button    name=query
    Wait Until Page Contains    Number of studies:    timeout=15s
    Wait Until Page Contains    1    timeout=15s
    ${MyResult} =    Get Text    xpath=//*[@id="command"]/div[2]/div[4]/table/tbody/tr[1]/td[2]/b
    Take My Screenshot


Test10
    [Documentation]    Click the button "Clean up" to delete the studies in the repository
    [Tags]    CRITICALITY HIGH
    Element Should Be Visible    name=delete
    Click Button    name=delete
    Handle Alert    action=ACCEPT    timeout=15s
    Wait Until Page Contains    Clean up success full    timeout=19s
    Take My Screenshot


Test11
    [Documentation]    Find the study in TMP Web
    [Tags]    CRITICALITY HIGH
    Wait Until Element Is Visible    link=My Patients    timeout=15s
    Element Should Be Visible    link=My Patients
    Click Link    link=My Patients
    Wait Until Page Contains   Birth Date    timeout=15s
    Wait Until Element Is Visible    id=searchInput    timeout=15s
    Element Should Be Visible    id=searchInput
    Input Text    id=searchInput    ${MyPatient5FamilyName}    clear=True
    Wait Until Keyword Succeeds    15s    3s    Textfield Value Should Be    id=searchInput    ${MyPatient5FamilyName}
    Press Keys    id=searchInput    ENTER
    Wait Until Page Contains    ${MyPatient5FamilyName} ${MyPatient5FirstName}    timeout=15s


Test12
    [Documentation]    The web page shows the message "Documents are not available"
    [Tags]    CRITICALITY HIGH
    Page Should Contain Link    link=${MyPatient5FamilyName} ${MyPatient5FirstName}    None    TRACE
    Click Link    link=${MyPatient5FamilyName} ${MyPatient5FirstName}
    Wait Until Page Contains    Documents are not available    timeout=15s
    Take My Screenshot


Test13
    [Documentation]    Enter the email address and then click the button "Republish documents"
    [Tags]    CRITICALITY NORMAL
    Wait Until Page Contains    Email Address:    timeout=15s
    Wait Until Element Is Visible    id=userEmail    timeout=15s
    Wait Until Element Is Visible    id=republishActionButton    timeout=15s
    Input Text    id=userEmail    ${TmpWebUser3Email}    clear=True
    Wait Until Keyword Succeeds    15s    3s    Textfield Value Should Be    id=userEmail    ${TmpWebUser3Email}
    Click Button    id=republishActionButton
    # The application takes about 43s to publish the study again
    Wait Until Page Contains    Documents are being published    timeout=99s
    Sleep    19s
    Take My Screenshot


Test14
    [Documentation]    Once TMP Tool Web has published the study completely, check that the document is available on the web page
    [Tags]    CRITICALITY NORMAL
    Wait Until Page Contains    ${MyPatient5FamilyName} ${MyPatient5FirstName}    timeout=300s
    Wait Until Page Contains    Download the following study    timeout=15s
    Wait Until Element Is Visible    link=DCM    timeout=15s
    Wait Until Element Is Visible    link=JPG    timeout=15s
    Wait Until Element Is Visible    link=${MyPatient5SeriesDescription}    timeout=15s
    Wait Until Page Contains    Anonymous link:    timeout=15s
    Wait Until Page Contains    Ordering physician:    timeout=15s
    Sleep    2s
    Take My Screenshot


Test15
    [Documentation]    Open the series with the image viewer
    [Tags]    CRITICALITY NORMAL
    Element Should Be Visible    link=${MyPatient5SeriesDescription}
    Click Link    link=${MyPatient5SeriesDescription}
    Wait Until Page Contains    Non-diagnostic quality    timeout=19s
    Wait Until Element Is Visible    link=Full screen    timeout=15s
    Wait Until Page Contains    ${MyPatient5FamilyName} ${MyPatient5FirstName}    timeout=15s
    Wait Until Element Is Visible    link=DICOM download    timeout=15s
    Wait Until Element Is Visible    link=JPEG download    timeout=15s
    Sleep    4s
    Take My Screenshot
    Log Out My User Session Of TMP Web
    Sleep    1s


Test16
    [Documentation]    User receives the email message informing that the document is available in TMP Web
    [Tags]    CRITICALITY NORMAL
    Go To    http://localhost:8070/
    Wait Until Page Contains    FakeSMTPServer    timeout=15s
    Wait Until Page Contains    Inbox    timeout=15s
    Wait Until Page Contains    ${TmpWebUser3Email}    timeout=15s
    Wait Until Page Contains    Documents available online    timeout=15s
    # CSS of the field "Documents available online"
    Wait Until Element Is Visible    css=.MuiDataGrid-cell:nth-child(4) > .MuiDataGrid-cellContent    timeout=15s
    Sleep    1s
    Click Element    css=.MuiDataGrid-cell:nth-child(4) > .MuiDataGrid-cellContent
    Wait Until Page Contains    Your documents are now available online    timeout=15s
    Take My Screenshot


Test17
    [Documentation]    Shut down the browser and reset the cache
    [Tags]    CRITICALITY LOW
    Close All Browsers
