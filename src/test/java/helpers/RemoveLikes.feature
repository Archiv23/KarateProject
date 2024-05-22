Feature: Remove lukes

Background: Define url
    * url apiURL

Scenario: Remove like
    Given path 'articles/'+slug+'/favorite'
    When method DELETE
    Then status 200