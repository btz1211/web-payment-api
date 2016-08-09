blueapron.controller('signUpCtrl', function($scope, $log, $window, $cookies, blueapronApi){
  $scope.user = {};
  $scope.user.planId = 1;

  //payment request
  $scope.hasPaymentRequestSupport = $window.PaymentRequest ? true : false;
  $scope.supportedInstruments = [{
      supportedMethods: [
        'visa', 'mastercard', 'amex', 'discover',
        'diners', 'jcb', 'unionpay'
      ]
  }];
  $scope.planDetails = {
    1: {
      label: '2-Person meal plan',
      price: '59.99'
    },
    2: {
      label: 'Family meal plan',
      price: '79.99'
    }
  }

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

  $scope.signUpWithPaymentRequest = function(){
    console.log("Signing up with payment request!");

    var details = {
      displayItems: [{
        label: $scope.planDetails[$scope.user.planId].label,
        amount: { currency: 'USD', value: $scope.planDetails[$scope.user.planId].price }
      }],
      total: {
        label: 'Total due',
        amount: { currency: 'USD', value: $scope.planDetails[$scope.user.planId].price }
      }
    }

    //implement signup with payment
    /*
    // 1. Create a `PaymentRequest` instance
    var request = new PaymentRequest($scope.supportedInstruments, details);

    // 2. Show the native UI with `.show()`
    request.show()

    // 3. Process the payment
    .then(paymentRequestResponseHandler);
    */
  }

  $scope.paymentRequestResponseHandler = function(response){
    //interact with the response
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

  $scope.changePlan = function(id){
    $scope.user.planId = id
  }
});
