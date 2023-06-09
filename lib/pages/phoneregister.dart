import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:animate_do/animate_do.dart';
import 'package:chatapp/components/Verification.dart';

class Phonereg extends StatefulWidget {
  const Phonereg({super.key});

  @override
  State<Phonereg> createState() => _PhoneregState();
}

class _PhoneregState extends State<Phonereg> {
  late String userphone;
  TextEditingController _controller = TextEditingController();
  int selectedIndex = 0;
  List<IconData> data = [
    Icons.phone,
    Icons.email,
  ];
  final TextEditingController controller = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(30),
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/phonereg.png',
                  fit: BoxFit.cover,
                  width: 280,
                ),
                SizedBox(
                  height: 50,
                ),
                FadeInDown(
                  child: Text(
                    'Verifying your number',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: <Color>[
                              Color.fromARGB(255, 42, 228, 188),
                              Color.fromARGB(246, 35, 194, 226),
                              Color.fromARGB(255, 211, 107, 252)
                            ],
                          ).createShader(
                              Rect.fromLTWH(0.0, 0.0, 200.0, 100.0))),
                  ),
                ),
                FadeInDown(
                  delay: Duration(milliseconds: 200),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20),
                    child: Text(
                      'Enter your phone number to continue, we will send you an OTP message to verifiy.',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey.shade700),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                FadeInDown(
                  delay: Duration(milliseconds: 400),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: Color.fromARGB(246, 0, 213, 255)
                              .withOpacity(0.7)),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xffeeeeee),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        InternationalPhoneNumberInput(
                          onInputChanged: (PhoneNumber number) {
                            print(number.phoneNumber);
                            userphone = number.phoneNumber!;
                          },
                          onInputValidated: (bool value) {
                            print(value);
                          },
                          selectorConfig: SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          ),
                          ignoreBlank: false,
                          autoValidateMode: AutovalidateMode.disabled,
                          selectorTextStyle: TextStyle(color: Colors.black),
                          textFieldController: controller,
                          formatInput: false,
                          maxLength: 10,
                          keyboardType: TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          cursorColor: Colors.black,
                          inputDecoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(bottom: 15, left: 0),
                            border: InputBorder.none,
                            hintText: 'Phone Number',
                            hintStyle: TextStyle(
                                color: Colors.grey.shade500, fontSize: 16),
                          ),
                          onSaved: (PhoneNumber number) {
                            print('On Saved: $number');
                          },
                        ),
                        Positioned(
                          left: 90,
                          top: 8,
                          bottom: 8,
                          child: Container(
                            height: 40,
                            width: 1,
                            color: Colors.black.withOpacity(0.13),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                FadeInDown(
                  delay: Duration(milliseconds: 600),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                      });

                      Future.delayed(Duration(seconds: 2), () {
                        setState(() {
                          _isLoading = false;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Verificatoin(
                                      phone: userphone,
                                    )));
                      });
                    },
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    child: _isLoading
                        ? Container(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              color: Colors.black,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            "Request OTP",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ));
  }
}
