'use strict'

angular.module('repoFinder')
.factory 'searchService', ($http)->

  github: (keyword, callback)->
    kw = String(keyword).replace /\s/g, "+"
    kw = "Hello+World" if kw.length == 0
    url = "https://api.github.com/search/repositories"
    $http.get( url + "?q=" + kw + "&per_page=100" )
    .success(callback)

  bitbucket: (keyword, callback)->
    kw = String(keyword).replace /\s/g, "+"
    kw = "Hello+World" if kw.length == 0
    url = "http://hi-ougi.com:8080/BbSearch/"
    $http.get( url + kw )
    .success(callback)

  gitorious: (keyword, callback)->
    kw = String(keyword).replace /\s/g, "+"
    kw = "Hello+World" if kw.length == 0
    url = "http://hi-ougi.com:8080/GrSearch/"
    $http.get( url + kw )
    .success(callback)

