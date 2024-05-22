@parallel=false
Feature: Home Work

    Background: Preconditions
        * url apiURL
        * def timeValidator = read ('classpath:helpers/timeValidator.js') 


    @ignore
    Scenario: Favorite articles
        * print 'the useremail is' , userEmail
        * def userInitials = userEmail.split('@')[0]
        * print userInitials
        # * print accessToken
        
        # Step 6: Get all favorite articles
        Given path 'articles'
        And params {favorited:"#(userInitials)", limit:5, offset:0}
        And method GET
        Then status 200
        And match response == {"articles": '#array', "articlesCount": '#number'}
        * def result = response.articles
        * print result

        # Step 7: Verify response schema
        # And match each response.articles ==
        # """
        #             {
        #                 "slug": "#string",
        #                 "title": "#string",
        #                 "description": "#string",
        #                 "body": "#string",
        #                 "tagList": '#array',
        #                 "createdAt": "#? timeValidator(_)",
        #                 "updatedAt": "#? timeValidator(_)",
        #                 "favorited": true,
        #                 "favoritesCount": '#number',
        #                 "author": {
        #                     "username": "#string",
        #                     "bio": null,
        #                     "image": "#string",
        #                     "following": '#boolean'
        #                 }
        #             }

        # """
    
      

