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
    $scope.removeMessages();
    blueapronApi.order($scope.user).$promise
    .then(function(response){
      $scope.showOrderMessage();
    }).catch(function(errors){
      $scope.showErrorMessage(errors);
    });
  }

  $scope.showOrderMessage = function(){
    console.log("Order Successful!");
    $('.error-alert').attr('hidden', 'true');
    $('.order-alert').removeAttr('hidden');
  }

  $scope.showErrorMessage = function(errors){
    $('.order-alert').attr('hidden', 'true');
    $('.error-alert').removeAttr('hidden');
    $('.error-message').text(errors);
  }

  $scope.removeMessages = function(){
    $('.order-alert').attr('hidden', 'true');
    $('.error-alert').attr('hidden', 'true');
  }

   $scope.getUser();
   $scope.setMessage();
});
