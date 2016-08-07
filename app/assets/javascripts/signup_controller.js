blueapron.controller('signUpCtrl', function($scope, $log, $window, $cookies, blueapronApi){
  $scope.user = {}

  $scope.signUp = function(){
    var $form = $('#sign-up-form');
    $form.submit(function(event) {
      // Disable the submit button to prevent repeated clicks:
      $form.find('.submit').prop('disabled', true);

      // Request a token from Stripe:
      Stripe.card.createToken($form, $scope.stripeResponseHandler);

      // Prevent the form from being submitted:
      return false;
    });
  }

  $scope.login = function(){
    blueapronApi.authenticateUser($scope.user).$promise
    .then(function(response){
      //redirect
      $window.location.href = '/';
    }).catch(function(error){
      var $form = $('#login-form');
      $form.find('.payment-errors').text(error.data.errors);
      $form.find('.alert-danger').removeAttr('hidden');
    })
  }

  $scope.stripeResponseHandler = function(status, response) {
    //Grab the form:
    var $form = $('#sign-up-form');

    if (response.error) {

      //Show the errors on the form:
      $form.find('.payment-errors').text(response.error.message);
      $form.find('.alert-danger').removeAttr('hidden');
      $form.find('.submit').prop('disabled', false); // Re-enable submission

    } else { // Token was created!

      $scope.user.creditCard.stripeToken = response.id;
      blueapronApi.createUser($scope.user).$promise
      .then(function(response){
        //redirect
        $window.location.href = '/';
      }).catch(function(error){
        $form.find('.payment-errors').text(error.data.errors);
        $form.find('.alert-danger').removeAttr('hidden');
      })
    }
  }
});
