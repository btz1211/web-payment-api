blueapron.controller('accountCtrl', function($scope, $routeParams, $window, $cookies, blueapronApi){
   $scope.user;
   $scope.message = "Welcome!";

   $scope.getUser = function(){
     try{
       $scope.user = JSON.parse($cookies.get('user'));
     }catch(error){
       console.log('cannot get signed-in user, due to: ' + error + ', redirecting to home...');
     }
   }

  $scope.setMessage = function(){
     if($scope.user){
       $scope.message = $scope.message + " " + $scope.user.firstName;
     }
   }

  $scope.redirectToSignup = function(){
     $window.location.href = '/signup';
   }

  $scope.order = function(){
    
  }
   $scope.getUser();
   $scope.setMessage();
});
