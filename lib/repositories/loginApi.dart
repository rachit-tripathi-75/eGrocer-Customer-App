import 'package:egrocer/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getLoginApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await sendApiRequest(
      apiName: ApiAndParams.apiLogin,
      params: params,
      isPost: true,
      context: context);

  return json.decode(response);
}

Future<Map<String, dynamic>> getRegisterApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await sendApiRequest(
    apiName: ApiAndParams.apiRegister,
    params: params,
    isPost: true,
    context: context,
  );

  return json.decode(response);
}

Future<Map<String, dynamic>> getUserVerifyApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await sendApiRequest(
      apiName: ApiAndParams.apiVerifyUser,
      params: params,
      isPost: true,
      context: context);

  return json.decode(response);
}
