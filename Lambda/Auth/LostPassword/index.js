console.log('Loading function');

// dependencies
var AWS = require('aws-sdk');
var crypto = require('crypto');

// Get reference to AWS clients
var dynamodb = new AWS.DynamoDB();
var ses = new AWS.SES();

var responseSuccess = {
	statusCode: 200,
	headers: {
		'Access-Control-Allow-Origin': '*'
	}
};

var responseError = {
	statusCode: 500,
	headers: {
		'Access-Control-Allow-Origin': '*'
	}
};

function getUser(event, email, fn) {
	dynamodb.getItem({
		TableName: event.stageVariables.auth_db_table,
		Key: {
			email: {
				S: email
			}
		}
	}, function(err, data) {
		if (err) return fn(err);
		else {
			if ('Item' in data) {
				fn(null, email);
			} else {
				fn(null, null); // User not found
			}
		}
	});
}

function storeLostToken(event, email, fn) {
	// Bytesize
	var len = 128;
	crypto.randomBytes(len, function(err, token) {
		if (err) return fn(err);
		token = token.toString('hex');
		dynamodb.updateItem({
				TableName: event.stageVariables.auth_db_table,
				Key: {
					email: {
						S: email
					}
				},
				AttributeUpdates: {
					lostToken: {
						Action: 'PUT',
						Value: {
							S: token
						}
					}
				}
			},
		 function(err, data) {
			if (err) return fn(err);
			else fn(null, token);
		});
	});
}

function sendLostPasswordEmail(event, email, token, fn) {
	var subject = 'Password Lost for ' + event.stageVariables.auth_application_name;
	var lostLink = event.stageVariables.auth_reset_page + '?email=' + encodeURIComponent(email) + '&lost=' + token;

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
					+ 'Please <a href="' + lostLink + '">click here to reset your password</a> or copy & paste the following link in a browser:'
					+ '<br><br>'
					+ '<a href="' + lostLink + '">' + lostLink + '</a>'
					+ '</body></html>'
				}
			}
		}
	}, fn);
}

exports.handler = function(event, context) {

	var payload = JSON.parse(event.body);

	var email = payload.email;

	getUser(event, email, function(err, emailFound) {
		if (err) {
			responseError.body = new Error('Error in getUserFromEmail: ' + err)
			context.fail(responseError);
		} else if (!emailFound) {
			console.log('User not found: ' + email);
			responseSuccess.body = JSON.stringify({
				sent: false
			})
			console.log("response: " + JSON.stringify(responseSuccess))
			context.succeed(responseSuccess);
		} else {
			storeLostToken(event, email, function(err, token) {
				if (err) {
					responseError.body = new Error('Error in storeLostToken: ' + err)
					context.fail(responseError);
				} else {
					sendLostPasswordEmail(event, email, token, function(err, data) {
						if (err) {
							responseError.body = new Error('Error in sendLostPasswordEmail: ' + err)
							context.fail(responseError);
						} else {
							console.log('User found: ' + email);
							responseSuccess.body = JSON.stringify({
								sent: true
							})
							console.log("response: " + JSON.stringify(responseSuccess))
							context.succeed(responseSuccess);
						}
					});
				}
			});
		}
	});
}
