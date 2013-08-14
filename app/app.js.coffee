gxj = angular.module 'gxj' , []

gxj.service 'pubnub', ->
  PUBNUB.init {
    publish_key   : 'pub-c-6ef9b6df-f175-4efd-881e-64e2e674380d'
    subscribe_key : 'sub-c-014219c8-04f1-11e3-a3d6-02ee2ddab7fe'
  }

gxj.controller 'AppCtrl', ['$scope', '$rootScope', 'pubnub' ($scope, $rootScope, pubnub) ->
  $rootScope.done = false
  $rootScope.percentage = 0
  $rootScope.current = 0
  $rootScope.target = 0

  update = (data) ->
    console.log 'DATA', data
    $rootScope.current = data.current
    $rootScope.target = data.target
    $rootScope.percentage = data.current * 100.0 / data.target

    if $scope.percentage >= 100
      $rootScope.done = true

  pubnub.subscribe {
    channel: "gamaroffxjtg"
    message: update
    #connect: publish
  }
]
