@parallel=false
Feature: Test the Articles functionality 

    Background: Define URL 
        Given url apiURL



    Scenario: Create new article   
        Given path 'articles'
        And request { "article": { "title": "Karate Class 7","description": "This is about karate learning",  "body": "Learn and become karate framework master", "tagList": ["karate, learn"  ]  }  }
        When method POST
        Then status 201
        And response.article.title == "Karate Class 7"
        * def articleID = response.article.slug

        Given params {limit: 10, offset: 0 }
        And path 'articles'
        When method GET
        Then status 200
        And match response.articles[0].title == "Karate Class 7"


        Given path 'articles/'+articleID
        When method DELETE
        Then status 204

        Given params {limit: 10, offset: 0 }
        And path 'articles'
        When method GET
        Then status 200
        And match response.articles[0].title != "Karate Class 7"




