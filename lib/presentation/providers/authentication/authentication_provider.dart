import 'package:provider/provider.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';

var authenticationProvider = [
  ChangeNotifierProvider(create: (_) => Authentication(),
  ),
];
