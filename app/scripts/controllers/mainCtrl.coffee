'use strict'

angular.module('repoFinder')
.controller 'mainCtrl', ($scope, $http, searchService)->
  $scope.keyword = ""
  $scope.init = ->
    $scope.res =
      gitCount: 0
      bbCount:  0
      grCount:  0
      repo: []

  $scope.search = searchService
  $scope.resShow = false

  $scope.doSearch = ->
    $scope.init()
    $scope.resShow = true
    $scope.search.github($scope.keyword, (data)->
      $scope.res.gitCount = data.total_count
      for item in data.items
        $scope.res.repo.push
          author:      String(item.full_name).split("/")[0]
          reponame:    String(item.full_name).split("/")[1]
          name:        item.full_name
          url:         item.html_url
          avatar:      item.owner.avatar_url
          description: item.description
          update:      Date.parse(item.updated_at)
          icon:        "fa fa-github fa-fw"
          from:        "Github"
    )
    $scope.search.bitbucket($scope.keyword, (data)->
      $scope.res.bbCount = data.total_count
      for item in data.items
        $scope.res.repo.push
          author:      String(item.Title).split("/")[0]
          reponame:    String(item.Title).split("/")[1]
          name:        item.Title
          url:         item.Url
          avatar:      item.Avatar
          description: item.Description
          update:      Date.parse(item.Date)
          icon:        "fa fa-bitbucket"
          from:        "Bitbucket"
    )
    $scope.search.gitorious($scope.keyword, (data)->
      $scope.res.grCount = data.total_count
      for item in data.items
        $scope.res.repo.push
          author:      String(item.Title).split("/")[0]
          reponame:    String(item.Title).split("/")[1]
          name:        item.Title
          url:         item.Url
          avatar:      "/images/Gitorious.png"
          description: item.Description
          update:      Date.parse(item.Date)
          icon:        ""
          from:        "Gitorious"
    )

