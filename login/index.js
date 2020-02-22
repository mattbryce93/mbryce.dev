const https = require('https');
const fs = require('fs');
const util = require('util');

const profileName = 'mbryce';

function promisedRequest(options, data = null) {
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
    if (data) {
      req.write(data);
    }
    req.end();
  });
}

const options = {
  hostname: 'app.terraform.io',
  path: '/api/v2/organizations',
  headers: {
    'content-type': 'application/vnd.api+json'
  },
  method: 'GET',
  protocol: 'https:'
};

async function updateVariables() {
  const awsCredentials = (
    await util.promisify(fs.readFile)(`${process.env['HOME']}/.aws/credentials`)
  ).toString();
  const terraformToken = `Bearer ${
    (await util.promisify(fs.readFile)(`${process.env['HOME']}/.terraformrc`))
      .toString()
      .split('=')[1]
      .split('"')[1]
  }`;
  options.headers.authorization = terraformToken;
  let finalCredentialsJson = {};
  awsCredentials
    .split('[')
    .filter(elements => elements)
    .map(profile => {
      usernameAndCredentials = profile.split(']');
      const profileName = usernameAndCredentials[0];
      const profileCredentials = usernameAndCredentials[1];
      let credentialsObject = {};
      profileCredentials
        .split('\n')
        .filter(empties => empties)
        .map(credEntry => {
          const result = {};
          keyAndValue = credEntry.split('=');
          result[
            `${keyAndValue[0]
              .toUpperCase()
              .split(' ')
              .join('')}`
          ] = keyAndValue[1].split(' ').join('');
          credentialsObject = { ...credentialsObject, ...result };
        });

      finalCredentialsJson[`${profileName}`] = credentialsObject;
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
            if (workspaceVariable.attributes.key === 'AWS_DEFAULT_REGION') {
              return;
            } else {
              options.path = `/api/v2/workspaces/${workspaceId}/vars/${workspaceVariable.id}`;
              options.method = 'PATCH';
              const payload = { data: workspaceVariable };
              payload.data.attributes.value =
                finalCredentialsJson[`${profileName}`][
                  `${workspaceVariable.attributes.key}`
                ];
              delete payload.data.relationships;
              delete payload.data.links;
              promisedRequest(options, JSON.stringify(payload)).then(result => {
                console.log(result);
              });
            }
          });
        });
      });
    })
    .catch(error => {
      console.error(error);
    });
}

updateVariables();
