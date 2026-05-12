// ignore_for_file: avoid_print
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tylunch/global/color.dart';
import 'package:tylunch/global/validator.dart';
import 'package:tylunch/global/widget.dart';
import 'package:tylunch/services/api/authentication.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  static final Authentication _authApi = Authentication();
  final CustomWidget cw = CustomWidget();
  bool isValidated = false;
  late final TextEditingController code,
      fname,
      lname,
      email,
      retypeEmail,
      password,
      retypepassword,
      telephone = TextEditingController(),
      byear;
  bool isobsecure = false;
  bool isobsecure1 = false;
  bool isloading = false;
  int month = 1, year = 2023;
  int index = 0;
  String dropdownvalue = ' ';

  var items = [
    ' ',
    'Janvier',
    'Fèvrier',
    'Mars',
    'Avril',
    'Mai',
    'Juin',
    'Juillet',
    'Aout',
    'Septembre',
    'Octobre',
    'Novembre',
    'Decembre'
  ];

  MaskTextInputFormatter phoneFormatter() {
    return MaskTextInputFormatter(
        mask: '+33 # ## ## ## ##', filter: {"#": RegExp(r'[0-9]')});
  }

  @override
  void initState() {
    super.initState();

    code = TextEditingController();
    fname = TextEditingController();
    lname = TextEditingController();
    email = TextEditingController();
    retypeEmail = TextEditingController();
    password = TextEditingController();
    retypepassword = TextEditingController();
    telephone.text = "+33 ";
    byear = TextEditingController();
    print("BIRTH MONTH INDEX: $index");
  }

  @override
  void dispose() {
    code.dispose();
    fname.dispose();
    lname.dispose();
    email.dispose();
    password.dispose();
    retypepassword.dispose();
    telephone.dispose();
    byear.dispose();
    super.dispose();
  }

  // register(String? firetoken) async {
  //   if (firetoken == null) return;
  //   await _authApi
  //       .register(
  //           email: email.text,
  //           name: fname.text,
  //           lastname: lname.text,
  //           password: password.text,
  //           code: code.text,
  //           telephone: telephone.text,
  //           firebaseId: firetoken,
  //           birthday: DateTime.parse(birthday.text),
  //           passwordConfirmation: retypepassword.text)
  //       .then((value) {
  //     if (value != null) {
  //       setState(() {
  //         isloading = false;
  //       });
  //       Fluttertoast.showToast(msg: "Compte créé avec succès");
  //       Navigator.pushNamed(context, '/landing_page');
  //     } else {
  //       setState(() {
  //         isloading = false;
  //       });
  //       // Navigator.pushNamed(context, '/login_page');
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: _formkey,
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 250,
                          alignment: Alignment.topRight,
                          child: Image.asset(
                            'assets/images/Frame 2601 (1).png',
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        Positioned(
                          top: 70,
                          left: 20,
                          child: SvgPicture.asset("assets/icons/Frame.svg"),
                        )
                      ],
                    ),
                    Container(
                      width: size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomWidget().title(
                            t1: "S",
                            t2: "'INSCRIRE",
                            s1: 40,
                            s2: 35,
                            color: kcPrimary,
                          ),
                          const Text(
                            "Je crée mon compte Ty Lunch",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Text(
                                "Code lieu de livraison",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                              // const SizedBox(width: 5),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      contentPadding: const EdgeInsets.only(
                                          top: 0,
                                          left: 25,
                                          right: 25,
                                          bottom: 10),
                                      iconPadding: const EdgeInsets.only(
                                          top: 5, right: 5, bottom: 0),
                                      icon: IconButton(
                                        alignment: Alignment.centerRight,
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        icon: const Icon(Icons.close_rounded),
                                      ),
                                      content: const Text(
                                          "Le Code lieu de livraison vous est délivré par Ty-Lunch."),
                                    ),
                                  );
                                },
                                icon: SvgPicture.asset("assets/icons/info.svg"),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 35,
                            child: TextFormField(
                              controller: code,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.characters,
                              validator: (value) {
                                return Validator.emptyfield(value ?? "");
                              },
                              onChanged: (String? newValue) {
                                setState(() {
                                  code.text = newValue?.toUpperCase() ?? "";
                                });
                              },
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 20),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.black),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          cw.textFormField(controller: lname, label: "Nom"),
                          const SizedBox(height: 10),
                          cw.textFormField(controller: fname, label: "Prénom"),
                          const SizedBox(height: 30),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  "Mois de naissance",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  "Année de naissance",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: DropdownButton(
                                    underline: Container(
                                      color: Colors.black,
                                      height: 1,
                                    ),
                                    isExpanded: true,
                                    value: dropdownvalue,
                                    elevation: 0,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    items: items.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownvalue = newValue!;
                                        index = items.indexOf(newValue) + 1;
                                        print("SELECTED INDEX: $index");
                                      });
                                    },
                                  ),
                                ),
                                // textFormField(
                                //     controller: bmonth,
                                //     label: "Mois de naissance"),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: SizedBox(
                                  height: 25,
                                  child: TextFormField(
                                    controller: byear,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.black),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TextFormField(
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              return Validator.validateEmail(value ?? "");
                            },
                            decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black),
                              ),
                              labelText: "Adresse Email",
                              labelStyle: TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: retypeEmail,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              return Validator.validateConfirmEmail(
                                  value ?? "", email.text);
                            },
                            decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black),
                              ),
                              labelText: "Confirmer votre adresse email",
                              labelStyle: TextStyle(color: Colors.black),
                            ),
                          ),
                          // cw.textFormField(
                          //   controller: email,
                          //   inputType: TextInputType.emailAddress,
                          //   label: "Adresse Email",
                          //   isEmail: true,
                          // ),
                          // const SizedBox(height: 10),
                          // cw.textFormField(
                          //   controller: retypeEmail,
                          //   inputType: TextInputType.emailAddress,
                          //   label: "Confirmer votre adresse email",
                          //   isEmail: true,
                          // ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text(
                                "Numéro de téléphone",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                              // const SizedBox(width: 5),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      contentPadding: const EdgeInsets.only(
                                          top: 0,
                                          left: 25,
                                          right: 25,
                                          bottom: 10),
                                      iconPadding: const EdgeInsets.only(
                                          top: 5, right: 5, bottom: 0),
                                      icon: IconButton(
                                        alignment: Alignment.centerRight,
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        icon: const Icon(Icons.close_rounded),
                                      ),
                                      content: const Text(
                                          "pour le 06 XX XX XX XX Indiquer : +33 6 XX XX XX XX"),
                                    ),
                                  );
                                },
                                icon: SvgPicture.asset("assets/icons/info.svg"),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: isValidated == false ? 25 : 50,
                            child: TextFormField(
                              controller: telephone,
                              keyboardType: TextInputType.number,
                              inputFormatters: [phoneFormatter()],
                              validator: (value) {
                                if (value!.isEmpty) {
                                  setState(() {
                                    isValidated = true;
                                  });
                                  return "ce champ est requis ou incorrect";
                                } else {
                                  if (value.length < 14) {
                                    setState(() {
                                      isValidated = !isValidated;
                                    });
                                    return "ce champ est requis ou incorrect";
                                  } else {
                                    return null;
                                  }
                                }
                                // if (value!.isNotEmpty) {
                                //   return Validator.validatePhoneNumber(value);
                                // } else {
                                // return Validator.validatePhoneNumber(value!);
                                // }
                              },
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 20),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.black),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          // TextFormField(
                          // controller: telephone,
                          // keyboardType: TextInputType.number,
                          // inputFormatters: [phoneFormatter()],
                          // validator: (value) {
                          //   if (value!.isNotEmpty) {
                          //     return Validator.validatePhoneNumber(value);
                          //   } else {
                          //     return Validator.emptyfield(value);
                          //   }
                          // },
                          //   decoration: const InputDecoration(
                          //     enabledBorder: UnderlineInputBorder(
                          //       borderSide:
                          //           BorderSide(width: 1, color: Colors.black),
                          //     ),
                          //     focusedBorder: UnderlineInputBorder(
                          //       borderSide:
                          //           BorderSide(width: 1, color: Colors.black),
                          //     ),
                          //     label: Text(
                          //       "Numéro de téléphone",
                          //       style: TextStyle(color: Colors.black),
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: password,
                            obscureText: !isobsecure,
                            validator: (value) {
                              return Validator.validatePassword(value ?? "");
                            },
                            decoration: InputDecoration(
                              enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black),
                              ),
                              labelText: "Mot de passe",
                              labelStyle: const TextStyle(color: Colors.black),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isobsecure = !isobsecure;
                                  });
                                },
                                icon: Icon(
                                  isobsecure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: kcPrimary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: retypepassword,
                            obscureText: !isobsecure1,
                            validator: (value) {
                              return Validator.validateConfirmPassword(
                                  value ?? "", password.text);
                            },
                            decoration: InputDecoration(
                              enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black),
                              ),
                              labelText: "Confirmez le mot de passe",
                              labelStyle: const TextStyle(color: Colors.black),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isobsecure1 = !isobsecure1;
                                  });
                                },
                                icon: Icon(
                                  isobsecure1
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: kcPrimary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),
                          Center(
                            child: SizedBox(
                              height: 60,
                              width: size.width * .65,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: pink,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(90),
                                  ),
                                ),
                                onPressed: () async {
                                  print(
                                      "Birthday month: $dropdownvalue / $index");
                                  print("Birthday year: ${byear.text}");
                                  print("PHONE NUMBER: ${telephone.text}");

                                  if (_formkey.currentState!.validate()) {
                                    setState(() {
                                      isloading = true;
                                      isValidated = true;
                                    });
                                    await _authApi
                                        .checkCompanyCode(code: code.text)
                                        .then((value) async {
                                      if (value == "exist") {
                                        print("exist");
                                        await _authApi
                                            .register(
                                          email: email.text,
                                          name: fname.text,
                                          lastname: lname.text,
                                          password: password.text,
                                          code: code.text.toUpperCase(),
                                          telephone: telephone.text,
                                          month: index == 0 ? null : index,
                                          year: byear.text.isEmpty
                                              ? null
                                              : int.parse(byear.text),
                                          passwordConfirmation:
                                              retypepassword.text,
                                        )
                                            .then((value) {
                                          if (value != null) {
                                            setState(() {
                                              isloading = false;
                                            });
                                            Fluttertoast.showToast(
                                                msg: "Compte créé avec succès");
                                            Navigator.pushNamed(
                                                context, '/landing_page');
                                            return;
                                          } else {
                                            setState(() {
                                              isloading = false;
                                            });
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Erreur lors de la création du compte");
                                            return;
                                          }
                                        });
                                      } else {
                                        print("not exist");
                                        Fluttertoast.showToast(
                                            msg: "le code n'existe pas");
                                      }
                                    });
                                  }
                                },
                                child: const Text(
                                  "CRÉER MON COMPTE",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: 'Déjà inscrit ? ',
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 16),
                                children: [
                                  TextSpan(
                                    text: ' Se connecter',
                                    style: const TextStyle(
                                      color: kcPrimary,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = (() {
                                        Navigator.pushNamed(
                                            context, '/login_page');
                                      }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 50)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              isloading ? CustomWidget().loader() : Container()
            ],
          ),
        ),
      ),
    );
  }
}
