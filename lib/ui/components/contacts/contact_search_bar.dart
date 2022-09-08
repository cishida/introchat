import 'package:flutter/material.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/ui/components/underline.dart';
import 'package:introchat/ui/screens/home/add_contact/add_contact.dart';

class ContactSearchBar extends StatelessWidget {
  const ContactSearchBar({
    Key key,
    @required TextEditingController controller,
  })  : _controller = controller,
        super(key: key);

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(
            15.0,
            0.0,
            15.0,
            10.0,
          ),
          child: TextFormField(
            style: TextStyle(
              color: ConstantColors.SECONDARY_TEXT,
              fontWeight: FontWeight.normal,
              fontSize: 17.0,
              // backgroundColor: ConstantColors.SECONDARY,
            ),
            decoration: InputDecoration(
              hintText: "Search",
              hintStyle: TextStyle(
                color: ConstantColors.SECONDARY_TEXT,
              ),
              contentPadding: EdgeInsets.fromLTRB(
                0.0,
                0.0,
                0.0,
                0.0,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: ConstantColors.SECONDARY,
                  width: 0.0,
                ),
                borderRadius: BorderRadius.circular(30.0),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              filled: true,
              fillColor: ConstantColors.SECONDARY,
              prefixIcon: Container(
                width: 28.0,
                margin: EdgeInsets.only(left: 10.0, right: 6.0),
                child: Image.asset(
                  'assets/images/magnifying-glass.png',
                  height: 25,
                  width: 25,
                ),
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<String>(
                      builder: (BuildContext context) {
                        return AddContact();
                      },
                      fullscreenDialog: true,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: 15.0,
                    margin: EdgeInsets.only(left: 10.0, right: 6.0),
                    child: Image.asset(
                      'assets/images/add-contact-button.png',
                      height: 20,
                      width: 20,
                    ),
                  ),
                ),
              ),
            ),
            controller: _controller,
          ),
        ),
        Underline(),
      ],
    );
  }
}
