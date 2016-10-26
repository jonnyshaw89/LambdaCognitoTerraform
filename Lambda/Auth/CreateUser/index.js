console.log('Loading function');

// dependencies
var AWS = require('aws-sdk');
var crypto = require('crypto');

// Get reference to AWS clients
var dynamodb = new AWS.DynamoDB();
var ses = new AWS.SES();

function computeHash(password, salt, fn) {
	// Bytesize
	var len = 128;
	var iterations = 4096;

	if (3 == arguments.length) {
		crypto.pbkdf2(password, salt, iterations, len, fn);
	} else {
		fn = salt;
		crypto.randomBytes(len, function(err, salt) {
			if (err) return fn(err);
			salt = salt.toString('base64');
			crypto.pbkdf2(password, salt, iterations, len, function(err, derivedKey) {
				if (err) return fn(err);
				fn(null, salt, derivedKey.toString('base64'));
			});
		});
	}
}

function storeUser(event, email, password, salt, fn) {
	// Bytesize
	var len = 128;
	crypto.randomBytes(len, function(err, token) {
		if (err) return fn(err);
		token = token.toString('hex');

		dynamodb.putItem({
			TableName: event.stageVariables.auth_db_table,
			Item: {
				email: {
					S: email
				},
				passwordHash: {
					S: password
				},
				passwordSalt: {
					S: salt
				},
				verified: {
					BOOL: false
				},
				verifyToken: {
					S: token
				}
			},
			ConditionExpression: 'attribute_not_exists (email)'
		}, function(err, data) {
			if (err) return fn(err);
			else fn(null, token);
		});
	});
}

function sendVerificationEmail(event, email, token, fn) {
	var subject = 'Verification Email for ' + event.stageVariables.auth_application_name;
	var verificationLink = event.stageVariables.auth_verification_page + '?email=' + encodeURIComponent(email) + '&verify=' + token;
	ses.sendEmail({
		Source: event.stageVariables.auth_email_from_address,
		Destination: {
			ToAddresses: [
				email
			]
		},
		Message: {
			Subject: {
				Data: subject
			},
			Body: {
				Html: {
					Data: '<html><head>'
					+ '<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />'
					+ '<title>' + subject + '</title>'
					+ '</head><body>'
					+ 'Please <a href="' + verificationLink + '">click here to verify your email address</a> or copy & paste the following link in a browser:'
					+ '<br><br>'
					+ '<a href="' + verificationLink + '">' + verificationLink + '</a>'
					+ '</body></html>'
				}
			}
		}
	}, fn);
}

exports.handler = function(event, context) {

	var responseCode = 200;

	var payload = JSON.parse(event.body);

	var email = payload.email;
	var clearPassword = payload.password;

	computeHash(clearPassword, function(err, salt, hash) {
		if (err) {
			context.fail(new Error('Error in hash: ' + err));
		} else {
			storeUser(event, email, hash, salt, function(err, token) {
				if (err) {
					if (err.code == 'ConditionalCheckFailedException') {
						// userId already found
						var response = {
							statusCode: responseCode,
							headers: {
							},
							body: JSON.stringify({
								created: false
							})
						};
						console.log("response: " + JSON.stringify(response))
						context.succeed(response);
					} else {
						context.fail(new Error('Error in storeUser: ' + err));
					}
				} else {
					sendVerificationEmail(event, email, token, function(err, data) {
						if (err) {
							context.fail(new Error('Error in sendVerificationEmail: ' + err));
						} else {
							var response = {
								statusCode: responseCode,
								headers: {
								},
								body: JSON.stringify({
									created: true
								})
							};
							console.log("response: " + JSON.stringify(response))
							context.succeed(response);
						}
					});
				}
			});
		}
	});
}
