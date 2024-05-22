@smoke
Feature: Tests for the home page

    Background: Define URL
        Given url apiURL

    Scenario: Get all tags
        Given path 'tags'
        When method Get
        Then status 200
        And match response.tags contains ['YouTube', 'Zoom']
        And match response.tags !contains 'cars'
        And match response.tags contains any ['fish', 'Enroll']
        And match response.tags == "#array"
        And match response.tags != "#string"
        And match each response.tags == "#string"


    Scenario: Get 10 articles from the home page
        * def timeValidator = read ("classpath:helpers/timeValidator.js")
        Given params { limit :5, offset: 0}
        Given path 'articles'
        When method Get
        Then status 200
        And match response == {"articles":'#[5]', "articlesCount":'#number'}
        And match response.articles[*].author.bio contains null
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
                "favorited": '#boolean',
                "favoritesCount": '#number',
                "author": {
                    "username": "#string",
                    "bio": "##string",
                    "image": "#string",
                    "following": '#boolean'
                }
            } 
                

        """
        

