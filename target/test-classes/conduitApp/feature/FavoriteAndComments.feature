@parallel=false
Feature: Home Work

    Background: Preconditions
        * url apiURL
        * def dataGenerator = Java.type('helpers.DataGenerator')
        * def timeValidator = read ('classpath:helpers/timeValidator.js') 

    Scenario: Conditional logic, set precondition for next scenario
        Given path 'articles'
        And params {limit : 5, offset:0}
        When method GET
        Then status 200
        * def article =  response.articles[0]
        * def isFavorite = response.articles[0].favorited

        * if (isFavorite == 1) karate.call ('classpath:helpers/RemoveLikes.feature', article)

        Given path 'articles'
        And params {limit : 10, offset:0}
        When method GET
        Then status 200
        And match response.articles[0].favorited == false

    @debug
    Scenario: Favorite articles
    * print 'the useremail is' , userEmail
    * def userInitials = userEmail.split('@')[0]
    * print userInitials
        
        # Step 1: Get atricles of the global feed
        Given path 'articles'
        And params {limit : 5, offset:0}
        When method GET
        Then status 200

        # Step 2: Get the favorites count and slug ID for the first arice, save it to variables
        * def slugID =  response.articles[0].slug
        * def initialfavCount = response.articles[0].favoritesCount
        * print slugID

        # Step 3: Make POST request to increse favorites count for the first article
        Given path 'articles/'+slugID+'/favorite'
        And request {}
        When method POST
        Then status 200

        # Step 4: Verify response schema
        And match response.article.favoritedBy[*].email contains userEmail
        And match response ==
        """
            {
                "article": {
                    "id": '#number',
                    "slug": "#(slugID)",
                    "title": "#string",
                    "description": "#string",
                    "body": "#string",
                    "createdAt": "#? timeValidator(_)",
                    "updatedAt": "#? timeValidator(_)",
                    "authorId": '#number',
                    "tagList": '#array',
                    "author": {
                        "username": "#string",
                        "bio": "##string",
                        "image": "#string",
                        "following": '#boolean'
                    },
                    "favoritedBy": '#array',
                    "favorited": true,
                    "favoritesCount": '#number'
                }
            }
        """
         * print initialfavCount
         * print response.article.favoritesCount
         * def Articletitle = response.article.title
        
        # # Step 5: Verify that favorites article incremented by 1
        #     #Example
        #      * def initialCount = initialfavCount
        #      * def response = {"favoritesCount": 1}
                * match response.article.favoritesCount == initialfavCount + 1
       
        # Step 6: Get all favorite articles
        Given path 'articles'
        And params {favorited:#(userInitials), limit:5, offset:0}
        And method GET
        Then status 200
        And match response == {"articles": '#array', "articlesCount": '#number'}

        # Step 7: Verify response schema
        And match each response.articles ==
        """
                    {
                        "slug": "#string",
                        "title": "#string",
                        "description": "#string",
                        "body": "#string",
                        "tagList": '#array',
                        "createdAt": "#? timeValidator(_)",
                        "updatedAt": "#? timeValidator(_)",
                        "favorited": true,
                        "favoritesCount": '#number',
                        "author": {
                            "username": "#string",
                            "bio": null,
                            "image": "#string",
                            "following": '#boolean'
                        }
                    }

        """
        # Step 8: Verify that slug ID from Step 2 exist in one of the favorite articles
        And match response.articles[*].slug contains slugID



    Scenario: Comment articles
        * def commenttext = dataGenerator.getRandomCommentString()
        # Step 1: Get atricles of the global feed
        Given path 'articles'
        And params {limit : 10, offset:0}
        When method GET
        Then status 200

        # Step 2: Get the slug ID for the first arice, save it to variable
        * def slugID =  response.articles[0].slug

        # Step 3: Make a GET call to 'comments' end-point to get all comments
        Given path 'articles/' +slugID +'/comments'
        When method GET
        And status 200
        # Step 4: Verify response schema
        And match response =={"comments":'#array'}

        # Step 5: Get the count of the comments array lentgh and save to variable
            #Example
            # * def responseWithComments = [{"article": "first"}, {article: "second"}]
            * def responseWithComments = response.comments
            * def CommentCount = responseWithComments.length
            * print CommentCount

        # Step 6: Make a POST request to publish a new comment
         Given path 'articles/' + slugID +'/comments'
         And request  {"comment":{"body":"#(commenttext)"}}
         When method POST
         And status 200

        # Step 7: Verify response schema that should contain posted comment text
        And match response ==
        """
            {
                "comment": {
                    "id": '#number',
                    "createdAt": "#? timeValidator(_)",
                    "updatedAt": "#? timeValidator(_)",
                    "body": "#(commenttext)",
                    "author": {
                        "username": "#string",
                        "bio": null,
                        "image": "#string",
                        "following": '#boolean'
                    }
                }
            }
        """

        # Step 8: Get the list of all comments for this article one more time
        Given path 'articles/' +slugID +'/comments'
        When method GET
        And status 200

        # Step 9: Verify number of comments increased by 1 (similar like we did with favorite counts)
        * def newresponseWithComments = response.comments
        * def newCommentCount = newresponseWithComments.length
        * match newCommentCount == CommentCount + 1

        
        # Step 10: Make a DELETE request to delete comment
        * def commentID = response.comments[0].id
        Given path 'articles/' + slugID + '/comments/' + commentID
        When method DELETE
        And status 200

        # Step 11: Get all comments again and verify number of comments decreased by 1
        Given path 'articles/' +slugID +'/comments'
        When method GET
        And status 200
        * def updatedCount = response.comments
        * def newCount = updatedCount.length
        * match newCount == newCommentCount - 1



