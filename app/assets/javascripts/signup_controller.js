blueapron.controller('signUpCtrl', function($scope, $log, $window, $cookies, blueapronApi){
  $scope.user = {};
  $scope.user.creditCard = {};
  $scope.user.planId = 1;

  //payment request
  $scope.hasPaymentRequestSupport = window.PaymentRequest ? true : false;

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
  };
  
  $scope.options = {
    requestPayerEmail: true,
    requestShipping: true
  };
  
  $scope.changePlan = function(id){
    $scope.user.planId = id;
  };
  
  $scope.login = function(){
    blueapronApi.authenticateUser($scope.user).$promise
    .then(function(response){
      //redirect
      $window.location.href = '/';
    }).catch(function(error){
      var $form = $('#login-form');
      $form.find('.payment-errors').text(error.data.errors);
      $form.find('.alert-danger').removeAttr('hidden');
    });
  };

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
  };

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
    };

    // 1. Create a `PaymentRequest` instance
    var request = new PaymentRequest($scope.supportedInstruments, details, $scope.options);
    
    request.addEventListener('shippingaddresschange', function(evt) {
      evt.updateWith(new Promise(function(resolve) {
        $scope.updateDetails(details, request.shippingAddress, resolve);
      }));
    });

    // 2. Show the native UI with `.show()`
    request.show()

    // 3. Process the payment
    .then($scope.paymentRequestResponseHandler)
    .catch(function(error){
      console.log(JSON.stringify(error));
    });
  };

  $scope.paymentRequestResponseHandler = function(response){
    console.log('sign up success! + ' + JSON.stringify(response));
    $scope.mapUserInfo(response);
    $scope.mapCardInfo(response.details);
    Stripe.card.createToken($scope.user.creditCard, $scope.stripeResponseHandler);
    response.complete('success');
  };

  $scope.stripeResponseHandler = function(status, response) {
    //Grab the form:
    var $form = $('#sign-up-form');

    if (response.error) {
      //Show the errors on the form:
      $form.find('.payment-errors').text(response.error.message);
      $form.find('.alert-danger').removeAttr('hidden');
      $form.find('.submit').prop('disabled', false); // Re-enable submission

    } else { // Token was created!

      $scope.user.creditCard.token = response.id;
      blueapronApi.createUser($scope.user).$promise
      .then(function(response){
        //redirect
        $window.location.href = '/';
      }).catch(function(error){
        $form.find('.payment-errors').text(error.data.errors);
        $form.find('.alert-danger').removeAttr('hidden');
      });
    }
  };
  
  //event listener for shipping address change
  $scope.updateDetails = function(details, shippingAddress, callback) {
    if (shippingAddress.country === 'US') {
      $scope.mapUserAddress(shippingAddress);

      var shippingOption = {
        id: 'default',
        label: 'Regular 2-day shipping',
        amount: {currency: 'USD', value: '0.00'},
        selected: true
      };
      
      details.displayItems.splice(2, 1, shippingOption);
      details.shippingOptions = [shippingOption];
      
    } else {
      // Don't ship outside of US for the purposes of this example.
      delete details.shippingOptions;
    }
    callback(details);
  };
  
  $scope.mapCardInfo= function(details){
    $scope.user.creditCard = {};
    $scope.user.creditCard.number = details.cardNumber;
    $scope.user.creditCard.cvc = details.cardSecurityCode;
    $scope.user.creditCard.exp_month = details.expiryMonth;
    $scope.user.creditCard.exp_year = details.expiryYear;
  };
  
  $scope.mapUserInfo = function(response){
    $scope.user.firstName = "Test";
    $scope.user.lastName = "User";
    $scope.user.email = response.payerEmail;
  };
  
  $scope.mapUserAddress = function(shippingAddress){
    $scope.user.address = {};
    $scope.user.address.addressLine1 = shippingAddress.addressLine[0];
    $scope.user.address.city = shippingAddress.city;
    $scope.user.address.state = shippingAddress.region;
    $scope.user.address.zip = shippingAddress.postalCode;
  };
});
