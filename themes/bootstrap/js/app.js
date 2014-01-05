'use strict';

var teahouseApp = angular.module('teahouseApp', []);

teahouseApp.controller('MainCtrl', function ($scope, $http, $location, $anchorScroll) {

  $scope.title    = '';
  $scope.messages = [];

  var data_path    = window.location.pathname + '.json?callback=JSON_CALLBACK';
  var message_path = window.location.pathname.replace(/admins|users/, 'messages');

  var client = new Faye.Client('/faye', {timeout: 120});

  $http
    .jsonp(data_path)
    .success(function (data, status) {
      if(status === 200){
        $scope.room     = data.room;
        $scope.title    = data.room.name;
        $scope.username = data.username;
        $scope.messages = data.messages;

        //Subscribe
        client.subscribe($scope.room.subscription, function (data) {
          $scope.$apply(function () {
            $scope.messages.push(data);
            $location.hash('bottom');
            $anchorScroll();
          });
        });

      }
    });

    $scope.addMessage = function () {
      var data = {username: $scope.username, content: $scope.msgContent};
      client.publish($scope.room.subscription, data);
      $http({
        method: 'POST',
        url: message_path,
        data: "content=" + $scope.msgContent,
        headers: {'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8'}
      });
      $scope.msgContent = '';
    }

    $scope.lastClass = function (last) {
      if(last){return 'animated bounce';}
    }

});
