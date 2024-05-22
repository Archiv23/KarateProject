function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
//Configure application URL
  var config = {
    apiURL: 'https://conduit-api.bondaracademy.com/api/'
  }
  
  if (env == 'dev') {
    config.userEmail = 'karateA1@test.com'
    config.userPassword = 'Test@123'
  } 
   if (env == 'qa') {
    config.userEmail = 'karate9@test.com'
    config.userPassword = 'Karate456'
  }


  var accessToken = karate.callSingle('classpath:helpers/CreateToken.feature', config).authToken
  karate.configure ('headers', {Authorization:'Token '+ accessToken})

  return config;
}