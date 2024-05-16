
Feature: Sign up of a new user


    Background: Preconditions
        * def dataGenerator = Java.type('helpers.DataGenerator')
        * url apiURL

    Scenario: New user sign up
        # Given def userData = {"email":"karateA3@test.com","username":"karateA3"} //embedded json object, embedded expression

        * def randomEmail = dataGenerator.getRandomEmail()
        * def randomUsername = dataGenerator.getRandomUsername()

        Given path 'users'
        And request 
        """
        {
            "user":   {
                "email":#(randomEmail),
                "password":"Test@123",
                "username":#(randomUsername)
            }
        }
        """
        When method POST
        Then status 201
        And match response == 
        """
            {
                "user": {
                    "id": '#number',
                    "email": #(randomEmail),
                    "username": #(randomUsername),
                    "bio": null,
                    "image": "#string",
                    "token": "#string"
                }
            }
        """
    @debug
    Scenario Outline: Validate Sign up for error messages
        * def randomEmail = dataGenerator.getRandomEmail()
        * def randomUsername = dataGenerator.getRandomUsername()

        Given path 'users'
        And request 
        """
        {
            "user":   {
                "email":"<email>",
                "password":"<password>",
                "username":"<username>"
            }
        }
        """
        When method  POST
        Then status 422
        And match response == <errorResponse>

        Examples:
            | email                     | password | username           | errorResponse                                        | 
            | monikageller@yopmail.com  | Test@123 | #(randomUsername)  | {"errors":{"email":["has already been taken"]}}      | 
            | #(randomEmail)            | Test@123 | corrinne.kuhic1    | {"errors":{"username":["has already been taken"]}}   | 
            |                           | Test@123 | #(randomUsername)  | {"errors":{"email":["can't be blank"]}}              | 
            | #(randomEmail)            |          | #(randomUsername)  | {"errors":{"password":["can't be blank"]}}           | 
            | #(randomEmail)            | Test@123 |                    | {"errors":{"username":["can't be blank"]}}           | 
            # //invalid email format
            # too long username
            # too short username
            # too short password
            
            
