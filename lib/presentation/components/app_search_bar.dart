import 'package:badges/badges.dart' as bd;
import 'package:igmp/shared/utils/debouncer.dart';
import 'package:flutter/material.dart';

class AppSearchBar extends StatefulWidget {
  const AppSearchBar({
    super.key,
    required this.onSearch,
    this.modalFiltro,
    this.badgeActive,
  });

  final void Function(String search) onSearch;
  final void Function()? modalFiltro;
  final bool? badgeActive;

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  final _formKey = GlobalKey<FormState>();

  final _controller = TextEditingController();

  // ignore: unused_field
  var _autoValidate = false;

  final _debouncer = Debouncer(milliseconds: 1000);

  void search(String value) {
    _debouncer.run(() {
      final isValid = _formKey.currentState!.validate();
      if (isValid) {
        widget.onSearch(value);
      } else {
        setState(() {
          _autoValidate = true;
        });
      }
    });
  }

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          children: [
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                prefixIcon: widget.modalFiltro == null
                    ? null
                    : IconButton(
                        icon: bd.Badge(
                          showBadge: widget.badgeActive ?? false,
                          // position: bd.BadgePosition(
                          //   top: -0.5,
                          //   end: -1,
                          // ),
                          // badgeColor: Colors.green,
                          child: Icon(Icons.filter_alt_outlined),
                        ),
                        onPressed: () {
                          widget.modalFiltro!();
                        },
                      ),
                suffixIcon: IconButton(
                  onPressed: () => {
                    widget.onSearch(''),
                    _controller.clear(),
                  },
                  icon: Icon(Icons.clear),
                ),
                hintText: 'Busca...',
                border: OutlineInputBorder(),
                filled: true,
                errorStyle: TextStyle(fontSize: 15),
              ),
              onChanged: (value) {
                _debouncer.run(() {
                  final isValid = _formKey.currentState!.validate();
                  if (isValid) {
                    widget.onSearch(value);
                  } else {
                    setState(() {
                      _autoValidate = true;
                    });
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
