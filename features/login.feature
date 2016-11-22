Feature: Login

        Scenario: See Login Page
                Given I am on the home page
                When I click "Log In "
                Then I should visit the login page
                
        Scenario: See Login Page
                Given I am on the home page
                When I click "Log In with NetID"
                Then I should visit the login_netid page            
