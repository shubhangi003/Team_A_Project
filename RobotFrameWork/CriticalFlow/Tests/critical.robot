*** Settings ***
Documentation           This is a test of a Pet Clinic with Robot Framework /Critical flow test
#Resource                ../Resources/30_Critical_Flow_Keywords.robot
Library                 SeleniumLibrary
Test Setup              BEGIN WEB TEST
Test Teardown           END WEB TEST



*** Variables ***
${BROWSER}                            chrome
${URL}                                 http://localhost:4200
${CF_FIRST_NAME_OWNER}                 Linda                      #Mona
${CF_LAST_NAME_OWNER}                  Björklund                  #Magnus
${CF_ADDRESS_OWNER}                    Main Avenue                #Medelgatan 3
${CF_CITY_OWNER}                       43212 Gothenburg           #12345 Stockholm
${CF_TELEPHONE_OWNER}                  0876543566                 #0701010101
${CF_PET_NAME_OWNER}                   Minnie                     #Morris
${CF_BIRTH_DATE_PET_OWNER}             2020/08/21                 #2019/05/25
${CF_VISIT_DATE_PET_1_OWNER}           2021/06/29                 #2021/06/21
${CF_DESCRIPTION_VISIT_PET_1_OWNER}    general checkup            #has problems with fur


*** Test Cases ***
User can access website and add a new pet owner
    [Documentation]             This is a test for critical flow: add user, add pet, add visit
    [Tags]                      Critical_flow_Test
    GIVEN Web page is open at start page
    WHEN the user find and click on OWNER menu
    AND find ALL List of OWNERS
    AND Verify all Column names for the OWNERS List
    AND click on "Add Owner" CF
    AND add a new Owner CF     ${CF_FIRST_NAME_OWNER}       ${CF_LAST_NAME_OWNER}     ${CF_ADDRESS_OWNER}      ${CF_CITY_OWNER}    ${CF_TELEPHONE_OWNER}
    AND verify that a new owner CF is saved in Owners Page
    AND then add Pet to the owner CF             ${CF_PET_NAME_OWNER}     ${CF_BIRTH_DATE_PET_OWNER}
    AND then add a visit for newly added pet CF         ${CF_VISIT_DATE_PET_1_OWNER}       ${CF_DESCRIPTION_VISIT_PET_1_OWNER}
    AND then verify the new booked visit for pet CF
    AND then verify the owner name is display with his pet name CF


*** Keywords ***
BEGIN WEB TEST
    Open browser                about:blank     ${BROWSER}
    Set Selenium speed          0.2

GIVEN Web page is open at start page

    Load Page
    Verify Page Loaded

Load Page
    Go to                       ${URL}

Verify Page Loaded
    ${link_text}                Get Title
    Should Be Equal             ${link_text}      SpringPetclinicAngular
    Page Should Contain         Welcome to Petclinic

WHEN the user find and click on OWNER menu
#Find "OWNERS" in menu and click on it
    wait until page contains            Owners
    Click Element                       xpath:/html/body/app-root/div[1]/nav/div/ul/li[2]

AND find ALL List of OWNERS
#Find ALL under OWNERS roll-down menu and click on it
    Page Should Contain Element         //*[@routerlink="/owners"]
    Click Element                       //*[@routerlink="/owners"]

AND Verify all Column names for the OWNERS List
#verify that we can see all menu and list with owners
    Page Should Contain                 Owners
    Page Should Contain Element         //*[@class="table table-striped"]
    Element Text Should be              //*[@class="table table-striped"]/thead/tr/th[1]      Name
    Element Text Should be              //*[@class="table table-striped"]/thead/tr/th[2]      Address
    Element Text Should be              //*[@class="table table-striped"]/thead/tr/th[3]      City
    Element Text Should be              //*[@class="table table-striped"]/thead/tr/th[4]      Telephone
    Element Text Should be              //*[@class="table table-striped"]/thead/tr/th[5]      Pets

AND click on "Add Owner" CF         #CF = Critical Flow
#We can click on menu button for "Add Owner"
    Click Element                       xpath:/html/body/app-root/app-owner-list/div/div/div/div/button

AND add a new Owner CF
# adding information about new owner 1
    [Arguments]                         ${CF_FIRST_NAME_OWNER}       ${CF_LAST_NAME_OWNER}     ${CF_ADDRESS_OWNER}      ${CF_CITY_OWNER}    ${CF_TELEPHONE_OWNER}
    Input Text                          id:firstName    ${CF_FIRST_NAME_OWNER}
    Input Text                          id:lastName     ${CF_LAST_NAME_OWNER}
    Input Text                          id:address      ${CF_ADDRESS_OWNER}
    Input Text                          id:city         ${CF_CITY_OWNER}
    Input Text                          id:telephone    ${CF_TELEPHONE_OWNER}
    Click Button                        xpath:/html/body/app-root/app-owner-add/div/div/form/div[7]/div/button[2]   #Click "Add owner" (under alll input) to save it
#We are back to the list with all owners

AND verify that a new owner CF is saved in Owners Page
#We are on the list with all owners
    wait until page contains                Owners
                                             #sleep          10s Page Should Contain
    Wait Until Element Is Visible       xpath:/html/body/app-root/app-owner-list/div/div/div/table/tbody/tr[11]/td[1]/a
    Element should be Visible           xpath:/html/body/app-root/app-owner-list/div/div/div/table/tbody/tr[11]/td[1]/a
    #xpath:/html/body/app-root/app-owner-list/div/div/div/table/tbody/tr[15]/td[1]/a     #We can see in the list Number 15 is Linda Björklund

AND then add Pet to the owner CF
#We start from a list with all owners
    [Arguments]                         ${CF_PET_NAME_OWNER}     ${CF_BIRTH_DATE_PET_OWNER}
    Click Element                       xpath:/html/body/app-root/app-owner-list/div/div/div/table/tbody/tr[11]/td[1]/a     #Click on the 11th owner on the list (Linda Björklund)
    Click Button                        xpath:/html/body/app-root/app-owner-detail/div/div/button[3]    #Click on "Add new pet"
    Input Text                          id:name    ${CF_PET_NAME_OWNER}
    Input Text                          xpath:/html/body/app-root/app-pet-add/div/div/form/div[4]/div/input    ${CF_BIRTH_DATE_PET_OWNER}
    Click Element                       //*[@id="type"]
    Click Element                       //*[@id="type"]/option[1]   #Choose option 1 Cat
    Click Button                        xpath:/html/body/app-root/app-pet-add/div/div/form/div[6]/div/button[2]   #Click on "add pet" to save new pet
    Wait Until Element Is Visible       xpath:/html/body/app-root/app-owner-detail/div/div/table[2]     #Wait until a table for added pet is visable
#We are now on the page with detailed information about towner 1: "Owner information" & "Pets and Visits"

AND then add a visit for newly added pet CF
#Add visit for user CF Linda Björklund cat Morris who has problems with fur
    [Arguments]                         ${CF_VISIT_DATE_PET_1_OWNER}       ${CF_DESCRIPTION_VISIT_PET_1_OWNER}
    Wait Until Element Is Visible       xpath:/html/body/app-root/app-owner-detail/div/div/table[2]/tr/app-pet-list/table/tr/td[1]/dl/button[3]      #button "Add Visit" is visable
    Click Button                        xpath:/html/body/app-root/app-owner-detail/div/div/table[2]/tr/app-pet-list/table/tr/td[1]/dl/button[3]      #Click on "Add Visit" for pet 2
    Wait Until Element Is Visible       xpath:/html/body/app-root/app-visit-add/div/div/h2      #verify that we are on the page for adding new visit and see "New Visit"
    Input Text                          //*[@id="visit"]/div[1]/div[1]/div/input        ${CF_VISIT_DATE_PET_1_OWNER}      #type a visit date
    Input Text                          id:description      ${CF_DESCRIPTION_VISIT_PET_1_OWNER}     #type description for visit
    Click Button                        //*[@id="visit"]/div[2]/div/button[2]       #Click on button "Add Visit"

AND then verify the new booked visit for pet CF
#We are now on the page with detailed information about owner 1: "Owner information" & "Pets and Visits"
#verify that a new visit is added and visable:
    Wait Until Element Is Visible       xpath:/html/body/app-root/app-owner-detail/div/div/table[2]/tr/app-pet-list/table/tr/td[2]

AND then verify the owner name is display with his pet name CF
#We are on the page with detailed information about towner 1: "Owner information" & "Pets and Visits"
    Wait Until Element Is Visible       xpath:/html/body/app-root/app-owner-detail/div/div/button[1]     #Wait until "Back" button is visible
    Click Button                        xpath:/html/body/app-root/app-owner-detail/div/div/button[1]    #Click on "Back" to go to the list with all owners
#We are back to the list with all owners

END WEB TEST
    Close Browser

