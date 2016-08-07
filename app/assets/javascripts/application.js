var blueapron = angular.module('blueapron', ['ngResource', 'ngRoute']);

blueapron.factory('blueapronApi', function($resource){
  var createUserResource = $resource("/api/v1/users");

  return {
    createUser: function(user){
      console.log('[INFO] - saving user::' + JSON.stringify(user));
       return createUserResource.save(user);
    }
  }
});
