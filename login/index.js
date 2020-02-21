const https = require('https');
const fs = require('fs');
const util = require('util');

function promisedRequest(options) {
  return new Promise((resolve, reject) => {
    const req = https.request(options, res => {
      res.setEncoding('utf8');
      let responseBody = '';

      res.on('data', chunk => {
        responseBody += chunk;
      });

      res.on('end', () => {
        resolve(JSON.parse(responseBody));
      });
    });

    req.on('error', err => {
      reject(err);
    });

    req.end();
  });
}

console.log(apiToken);
const options = {
  hostname: 'app.terraform.io',
  path: '/api/v2/organizations',
  headers: {
    'content-type': 'application/vnd.api+json',
    authorization: 'Bearer <redacted api token'
  },
  method: 'GET',
  protocol: 'https:'
};

async function updateVariables() {
  const awsCredentials = (
    await util.promisify(fs.readFile)(`${process.env['HOME']}/.aws/credentials`)
  ).toString();
  awsCredentials
    .split('[')
    .filter(elements => elements)
    .map(profile => {
      usernameAndCredentials = profile.split(']');
      const profileName = usernameAndCredentials[0];
      const profileCredentials = usernameAndCredentials[1];
      console.log(profileName);
      console.log(profileCredentials);
      let credentialsObject = {};
      profileCredentials
        .split('\n')
        .filter(empties => empties)
        .map(credEntry => {
          const result = {};
          keyAndValue = credEntry.split('=');
          result[`${keyAndValue[0]}`] = keyAndValue[1];
          credentialsObject = { ...credentialsObject, ...result };
        });
      console.log(credentialsObject);
    });
  return await promisedRequest(options)
    .then(test => {
      const organizationName = test.data[0].id;
      options.path += `/${organizationName}/workspaces`;
      return promisedRequest(options).then(result => {
        const workspaceId = result.data[0].id;
        options.path = `/api/v2/workspaces/${workspaceId}/vars`;
        return promisedRequest(options).then(workspaceVariables => {
          return workspaceVariables.data.map(workspaceVariable => {
            console.log(workspaceVariable.attributes.key);
          });
        });
      });
    })
    .catch(error => {
      console.error(error);
    });
}

updateVariables();
