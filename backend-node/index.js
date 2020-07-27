var request = require('request');
var _ = require("underscore");
var fs = require('fs');
const uuid = require('uuid');

const express = require('express');
const bodyParser = require('body-parser');

let path = __dirname + "/src/files/Banco_1"
let certificate = fs.readFileSync(`${path}/certs/client_certificate.crt`)
let private_key = fs.readFileSync(`${path}/certs/client_private_key.key`)

let env_file = fs.readFileSync(`${path}/environment.json`, 'utf8')
var env_json = JSON.parse(env_file);

const mock_token = process.env.MOCK_TOKEN

function valueForEnvKey(key) {
  let filtered = _.where(env_json.values, {key: `${key}`})[0]
  return filtered.value
}

function ObterCredencial(callback) {
  var options = {
    'method': 'POST',
    'url': valueForEnvKey("tokenEndpoint"),
    'headers': {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': `Basic ${valueForEnvKey("basicToken")}`
    },
    form: {
      'grant_type': 'client_credentials',
      'scope': 'accounts openid'
    },
    'key': private_key,
    'cert': certificate,
    rejectUnauthorized: false
  };
  
  request(options, function (error, response) {
    if (error) throw new Error(error);
    let json = JSON.parse(response.body)
    console.log(json)
    CriacaoConsentimento(json.access_token, callback)
  });
}

function CriacaoConsentimento(access_token, callback) {
  var options = {
    'method': 'POST',
    'url': `${valueForEnvKey("rs")}/open-banking/v3.1/aisp/account-access-consents`,
    'headers': {
      'Content-Type': 'application/json',
      'x-fapi-financial-id': valueForEnvKey("obParticipantId"),
      'x-fapi-interaction-id': uuid.v4(),
      'Authorization': `Bearer ${access_token}`
    },
    body: JSON.stringify({"Data":{"Permissions":["ReadAccountsBasic","ReadAccountsDetail","ReadBalances","ReadBeneficiariesBasic","ReadBeneficiariesDetail","ReadDirectDebits","ReadTransactionsBasic","ReadTransactionsCredits","ReadTransactionsDebits","ReadTransactionsDetail","ReadProducts","ReadStandingOrdersDetail","ReadProducts","ReadStandingOrdersDetail","ReadStatementsDetail","ReadParty","ReadOffers","ReadScheduledPaymentsBasic","ReadScheduledPaymentsDetail","ReadPartyPSU"]},"Risk":{}}),
    'key': private_key,
    'cert': certificate,
    rejectUnauthorized: false
  };
  request(options, function (error, response) {
    if (error) throw new Error(error);
    let json = JSON.parse(response.body).Data
    let obj = {
        ConsentId: json.ConsentId,
        Status: json.Status
    }
    console.log(obj);
    ObterURLRedirect(obj.ConsentId, callback)
  });  
}

function ValidacaoCriacaoConsentimento(accountAccessConsentId, access_token) {
  var request = require('request');
  var options = {
    'method': 'GET',
    'url': `${valueForEnvKey("rs")}/open-banking/v3.1/aisp/account-access-consents/${accountAccessConsentId}`,
    'headers': {
      'Content-Type': 'application/json',
      'x-fapi-financial-id': valueForEnvKey("obParticipantId"),
      'x-fapi-interaction-id': uuid.v4(),
      'Authorization': `Bearer ${access_token}`
    },
    'key': private_key,
    'cert': certificate,
    rejectUnauthorized: false
  };
  request(options, function (error, response) {
    if (error) throw new Error(error);
    let json = JSON.parse(response.body).Data
    let obj = {
        ConsentId: json.ConsentId,
        Status: json.Status
    }
    console.log(obj)
  });
}

function ObterURLRedirect(ConsentId, callback) {
  var options = {
    'method': 'GET',
    'url': `${valueForEnvKey("rs")}/ozone/v1.0/auth-code-url/${ConsentId}?scope=accounts&alg=none`,
    'headers': {
      'Authorization': `Basic ${valueForEnvKey("basicToken")}`
    },
    'key': private_key,
    'cert': certificate,
    rejectUnauthorized: false
  };
  request(options, function (error, response) {
    if (error) throw new Error(error);
    console.log(response.body)
    callback(response.body)
  });
}

function ObterTokenCodigoAutorizacaoAcessarDados(code, callback) {
  var options = {
    'method': 'POST',
    'url': valueForEnvKey("tokenEndpoint"),
    'headers': {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': `Basic ${valueForEnvKey("basicToken")}`
    },
    form: {
      'grant_type': 'authorization_code',
      'scope': 'accounts ',
      'code': code,
      'redirect_uri': 'http://www.google.co.uk'
    },
    'key': private_key,
    'cert': certificate,
    rejectUnauthorized: false
  };
  request(options, function (error, response) {
    if (error) throw new Error(error);
    console.log(JSON.parse(response.body));
    callback(response.body)
  });  
}

function ObterContas(tokenFromAuthCodeGrantAccounts, callback) {
  var options = {
    'method': 'GET',
    'url': `${valueForEnvKey("rs")}/open-banking/v3.1/aisp/accounts`,
    'headers': {
      'Content-Type': 'application/json',
      'x-fapi-financial-id': valueForEnvKey("obParticipantId"),
      'x-fapi-interaction-id': uuid.v4(),
      'Authorization': `Bearer ${tokenFromAuthCodeGrantAccounts}`
    },
    'key': private_key,
    'cert': certificate,
    rejectUnauthorized: false
  };
  request(options, function (error, response) {
    if (error) throw new Error(error);
    console.log(response.body)
    callback(response.body)
    let json = JSON.parse(response.body).Data
    console.log(json);
  });  
}

function ObterSaldos(tokenFromAuthCodeGrantAccounts, callback) {
  var options = {
    'method': 'GET',
    'url': `${valueForEnvKey("rs")}/open-banking/v3.1/aisp/balances`,
    'headers': {
      'Content-Type': 'application/json',
      'x-fapi-financial-id': valueForEnvKey("obParticipantId"),
      'x-fapi-interaction-id': uuid.v4(),
      'Authorization': `Bearer ${tokenFromAuthCodeGrantAccounts}`
    },
    'key': private_key,
    'cert': certificate,
    rejectUnauthorized: false
  };
  request(options, function (error, response) {
    if (error) throw new Error(error);
    // console.log(response.body);
    callback(response.body)
  });  
}

function ObterTransacoes(tokenFromAuthCodeGrantAccounts, callback) {
  var options = {
    'method': 'GET',
    'url': `${valueForEnvKey("rs")}/open-banking/v3.1/aisp/transactions`,
    'headers': {
      'Content-Type': 'application/json',
      'x-fapi-financial-id': valueForEnvKey("obParticipantId"),
      'x-fapi-interaction-id': uuid.v4(),
      'Authorization': `Bearer ${tokenFromAuthCodeGrantAccounts}`
    },
    'key': private_key,
    'cert': certificate,
    rejectUnauthorized: false
  };
  request(options, function (error, response) {
    if (error) throw new Error(error);
    // console.log(response.body);
    callback(response.body)
  });  
}

function ListaATM(callback) {
  var options = {
    'method': 'GET',
    'url': `${valueForEnvKey("rs")}/open-banking/v2.3/atms`,
    'key': private_key,
    'cert': certificate,
    rejectUnauthorized: false
  };
  request(options, function (error, response) {
    if (error) throw new Error(error);
    // console.log(response.body);
    callback(response.body)
  });
}

function ListaAgencia(callback) {
  var options = {
    'method': 'GET',
    'url': `${valueForEnvKey("rs")}/open-banking/v2.3/branches`,
    'key': private_key,
    'cert': certificate,
    rejectUnauthorized: false
  };
  request(options, function (error, response) {
    if (error) throw new Error(error);
    // console.log(response.body);
    callback(response.body)
  });
}

function ListaProduto(callback) {
  var options = {
    'method': 'GET',
    'url': `${valueForEnvKey("rs")}/open-banking/v2.4/personal-current-accounts`,
    'key': private_key,
    'cert': certificate,
    rejectUnauthorized: false
  };
  request(options, function (error, response) {
    if (error) throw new Error(error);
    // console.log(response.body);
    callback(response.body)
  });
}

const port = process.env.PORT || 8080
const app = express();

app.use(bodyParser.json());

app.get('/', function (req, res){
    res.send("HELLO")
});

app.get('/consentimento', function (req, res){
  ObterCredencial(function(url) {
     res.send(url)
  })
});

app.get('/token', function (req, res){
  let code = req.query.code
  ObterTokenCodigoAutorizacaoAcessarDados(code, function(body) {
     res.send(body)
  })
});

app.get('/account', function (req, res){
  ObterContas(mock_token, function(body) {
    res.send(body)
  })
});

app.get('/balance', function (req, res){
  ObterSaldos(mock_token, function(body) {
    res.send(body)
  })
});

app.get('/transactions', function (req, res){
  ObterTransacoes(mock_token, function(body) {
    res.send(body)
  })
});

app.get('/atms', function (req, res){
  ListaATM(function(body) {
    res.send(body)
  })
});

app.get('/branches', function (req, res){
  ListaAgencia(function(body) {
    res.send(body)
  })
});

app.get('/produtos', function (req, res){
  ListaProduto(function(body) {
    res.send(body)
  })
});

app.use(function(req, res){
    res.status(400).json({
        error: true
    })
});

app.listen(port, function() {
    console.log(`Servidor iniciou na porta ${port}`)
});
