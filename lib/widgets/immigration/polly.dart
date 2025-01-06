// import 'dart:convert';

// import 'package:aws_common/aws_common.dart';
// import 'package:aws_signature_v4/aws_signature_v4.dart';

// // Create the signer instance with credentials from the environment.
// const AWSSigV4Signer signer = AWSSigV4Signer(
//   credentialsProvider: AWSCredentialsProvider.environment(),
// );

// // Create the signing scope and HTTP request
// const region = '<YOUR-REGION>';

// Future<void> _synthesizeSpeech() async {
//   final scope = AWSCredentialScope(
//     region: region,
//     service: AWSService.cognitoIdentityProvider,
//   );

//   final request = AWSHttpRequest(
//     method: AWSHttpMethod.post,
//     uri: Uri.https('cognito-idp.$region.amazonaws.com', '/'),
//     headers: const {
//       AWSHeaders.target: 'AWSCognitoIdentityProviderService.DescribeUserPool',
//       AWSHeaders.contentType: 'application/x-amz-json-1.1',
//     },
//     body: json.encode({
//       'UserPoolId': '<YOUR-USER-POOL-ID>',
//     }).codeUnits,
//   );

//   // Sign and send the HTTP request
//   final signedRequest = await signer.sign(
//     request,
//     credentialScope: scope,
//   );
//   final resp = signedRequest.send();
//   final respBody = await resp.decodeBody();
//   safePrint(respBody);
// }
//