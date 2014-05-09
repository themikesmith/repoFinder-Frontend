'use strict'

angular.module('repoFinder')
.controller 'mainCtrl', ($scope, $http)->
  $scope.resShow = false
  $scope.searchRes = []
  $scope.url = "https://api.github.com/search/repositories"
  $scope.doSearch = ->
    $http.get( $scope.url + "?q=" + $scope.keyword )
    .success ( data )->
      $scope.resShow = true
      $scope.count = data.total_count
      $scope.searchRes = []
      for item in data.items
        $scope.searchRes.push
          name:   item.full_name
          url:    item.html_url
          avatar: item.owner.avatar_url
