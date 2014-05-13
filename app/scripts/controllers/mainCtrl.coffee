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


  $scope.sortOpts = [
    { opt: 0, desc: "Relevance" },
    { opt: 1, desc: "Date (Newest to Oldest)"},
    { opt: 2, desc: "Date (Oldest to Newest)"}
  ]
  $scope.sortOption = $scope.sortOpts[0]

  $scope.changeSort = (opt)->
    $scope.sortOption = opt
    switch opt.opt
      when 0
        total_count = $scope.res.gitCount + $scope.res.bbCount + $scope.res.grCount
        $scope.res.repo.sort (a, b)->
          score_a = ( a.rank / total_count ) * a.weight
          score_b = ( b.rank / total_count ) * b.weight
          return score_a - score_b
      when 1
        $scope.res.repo.sort (a, b)->
          return b.update - a.update
      when 2
        $scope.res.repo.sort (a, b)->
          return a.update - b.update

  $scope.$watch('res', (nv, ov)->
    if nv != ov
      $scope.changeSort($scope.sortOption)
  , true )

  $scope.doSearch = ->
    $scope.init()
    $scope.resShow = true
    $scope.search.github($scope.keyword, (data)->
      $scope.res.gitCount = data.total_count
      rank = 1
      for item in data.items
        $scope.res.repo.push
          author:      String(item.full_name).split("/")[0]
          reponame:    String(item.full_name).split("/")[1]
          rank:        rank
          name:        item.full_name
          url:         item.html_url
          avatar:      item.owner.avatar_url
          description: item.description
          update:      Date.parse(item.updated_at)
          icon:        "fa fa-github fa-fw"
          from:        "Github"
          weight:      ( 1 / Math.log(data.total_count) )
        rank++
    )
    $scope.search.bitbucket($scope.keyword, (data)->
      $scope.res.bbCount = data.total_count
      rank = 1
      for item in data.items
        $scope.res.repo.push
          author:      String(item.Title).split("/")[0]
          reponame:    String(item.Title).split("/")[1]
          rank:        rank
          name:        item.Title
          url:         item.Url
          avatar:      item.Avatar
          description: item.Description
          update:      Date.parse(item.Date)
          icon:        "fa fa-bitbucket"
          from:        "Bitbucket"
          weight:      ( 1 / Math.log(data.total_count) )
        rank++
    )
    $scope.search.gitorious($scope.keyword, (data)->
      $scope.res.grCount = data.total_count
      rank = 1
      for item in data.items
        $scope.res.repo.push
          author:      String(item.Title).split("/")[0]
          reponame:    String(item.Title).split("/")[1]
          rank:        rank
          name:        item.Title
          url:         item.Url
          avatar:      "/images/Gitorious.png"
          description: item.Description
          update:      Date.parse(item.Date)
          icon:        ""
          from:        "Gitorious"
          weight:      ( 1 / Math.log(data.total_count) )
        rank++
    )

