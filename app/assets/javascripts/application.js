var blueapron = angular.module('blueapron', ['ngResource', 'ngRoute', 'ngCookies']);

blueapron.factory('blueapronApi', function($resource){
  var createUserResource = $resource("/api/v1/users");
  var authenticateUserResource = $resource("/api/v1/users/authenticate");

  return {
    createUser: function(user){
      console.log('[INFO] - saving user::' + JSON.stringify(user));
       return createUserResource.save(user);
    },

    authenticateUser: function(user){
      return authenticateUserResource.get({email: user.email, password: user.password});
    }
  }
});
