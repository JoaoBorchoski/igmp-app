import 'dart:io';
import 'package:igmp/data/repositories/common/user_repository.dart';
import 'package:igmp/domain/models/authentication/authentication.dart';
import 'package:igmp/presentation/components/app_loading.dart';
import 'package:igmp/presentation/components/utils/load_user_data.dart';
import 'package:igmp/shared/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AvatarPage extends StatefulWidget {
  const AvatarPage({super.key});

  @override
  State<AvatarPage> createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> {
  bool _isLoading = false;
  String? _avatar;
  final ImagePicker _picker = ImagePicker();

  Future<void> _loadAavatar() async {
    final data = await loadUserData();
    _avatar = data.avatar;
  }

  Future<void> _selectImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() => _isLoading = true);

    final newAvatar = image != null ? File(image.path) : null;

    await Provider.of<UserRepository>(context, listen: false).uploadAvatar(newAvatar).then((response) async {
        if (response != null) {
          Authentication authentication = Provider.of(context, listen: false);
          await authentication.updateAvatar(response['avatarUrl']);
          setState(() => _avatar = response['avatarUrl']);
        }
        setState(() => _isLoading = false);
      },
    );
  }

  Widget get _undefinedAvatar {
    return FittedBox(
      fit: BoxFit.fill,
      child: Icon(
        Icons.account_circle,
        color: AppColors.background,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async {
        bool retorno = true;
        Navigator.of(context).pushReplacementNamed('/home');
        return retorno;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(children: [
          Positioned(
            top: 30.0,
            left: 0.0,
            child: IconButton(
              color: AppColors.background,
              onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
              icon: Icon(Icons.arrow_back),
            ),
          ),
          FutureBuilder(future: _loadAavatar(),
            builder: (context, snapshot) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _avatar != null
                      ? SizedBox(width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width,
                          child: Container(decoration: BoxDecoration(color: AppColors.white),
                            child: Image.network(
                              fit: BoxFit.cover,
                              _avatar!,
                              errorBuilder: (context, error, stackTrace) {
                                return _undefinedAvatar;
                              },
                            ),
                          ),
                        )
                      : SizedBox(width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width,
                          child: _undefinedAvatar,
                        ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _selectImage,
                    child: Text('Alterar'),
                  ),
                ],
              );
            },
          ),
          _isLoading == true ? LoadWidget(opacity: 0.5) : SizedBox.shrink(),
        ]),
      ),
    );
  }
}
