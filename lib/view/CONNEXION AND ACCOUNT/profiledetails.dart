// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tylunch/global/color.dart';
import 'package:tylunch/global/container.dart';
import 'package:tylunch/global/validator.dart';
import '../../global/widget.dart';
import '../../model/user.dart';
import '../../services/api/authentication.dart';
import '../landing.dart';

class ProfileDetailsPage extends StatefulWidget {
  const ProfileDetailsPage({super.key, required this.onUpdateCallback});
  final ValueChanged<UserModel> onUpdateCallback;

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  late final TextEditingController code = TextEditingController(),
      address = TextEditingController(),
      name = TextEditingController(),
      lname = TextEditingController(),
      email = TextEditingController(),
      telephone = TextEditingController(),
      bmonth = TextEditingController(),
      byear = TextEditingController();
  final Authentication auth = Authentication();
  final CustomWidget cw = CustomWidget();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool isloading = false;
  int index = 0;
  late String dropdownvalue = ' ';

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
    if (items.asMap().containsKey(loggedUser!.month)) {
      print('Exists');
      int? monInd = loggedUser!.month;
      print("MONTH ${items[monInd!]} - $monInd");
      index = monInd;
      dropdownvalue = items[monInd];
      print(dropdownvalue);
    }

    code.text = loggedUser?.code ?? "";
    address.text = loggedUser?.company.deliveryLocation ?? "";
    name.text = loggedUser?.name ?? "";
    lname.text = loggedUser?.lastname ?? "";
    email.text = loggedUser?.email ?? "";
    telephone.text = loggedUser?.telephone ?? "+33 ";
    // dropdownvalue = "${loggedUser?.month ?? ' '}";
    byear.text = "${loggedUser?.year ?? ""}";
    super.initState();
  }

  @override
  void dispose() {
    code.dispose();
    address.dispose();
    name.dispose();
    lname.dispose();
    email.dispose();
    telephone.dispose();
    bmonth.dispose();
    byear.dispose();
    super.dispose();
  }

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Stack(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/newLogo.svg",
                                width: 300,
                              ),
                              const Positioned(
                                top: 5,
                                left: 25,
                                child: Text(
                                  "Modifier\nmon profil",
                                  style: TextStyle(
                                    fontFamily: 'CraftRounded',
                                    fontSize: 25,
                                    color: kcPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 20,
                            right: 20,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            LandingPage(ind: 2)),
                                    (Route<dynamic> route) => false);
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    padding: const EdgeInsets.all(0),
                                    child: Image.asset(
                                      "assets/images/cart.png",
                                      color: kcPrimary,
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: CustomWidget().cartQty(),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: SvgPicture.asset(
                                  "assets/icons/chevron-left.svg",
                                  width: 30),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          cw.textFormField(
                              controller: code,
                              label: "Code lieu de livraison"),
                          const SizedBox(height: 10),
                          cw.textFormField(
                              controller: address,
                              isfromLogin: true,
                              label: "Lieu de livraison"),
                          const SizedBox(height: 10),
                          cw.textFormField(controller: lname, label: "Nom"),
                          const SizedBox(height: 10),
                          cw.textFormField(controller: name, label: "Prénom"),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: RichText(
                                  text: const TextSpan(
                                    text: "Mois de naissance",
                                    style: TextStyle(color: Colors.black),
                                    children: [
                                      TextSpan(
                                        text: " *",
                                        style: TextStyle(color: Colors.orange),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: RichText(
                                  text: const TextSpan(
                                    text: "Année de naissance",
                                    style: TextStyle(color: Colors.black),
                                    children: [
                                      TextSpan(
                                        text: " *",
                                        style: TextStyle(color: Colors.orange),
                                      )
                                    ],
                                  ),
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
                                    value: dropdownvalue.isEmpty
                                        ? ' '
                                        : dropdownvalue,
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
                                        index = items.indexOf(newValue);
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
                              )
                                  // textFormField(
                                  //     controller: byear,
                                  //     label: "Année de naissance"),
                                  ),
                            ],
                          ),
                          // TextFormField(
                          //   controller: birthday,
                          //   validator: (value) {
                          //     return Validator.emptyfield(value ?? "");
                          //   },
                          //   decoration: const InputDecoration(
                          //     enabledBorder: UnderlineInputBorder(
                          //       borderSide:
                          //           BorderSide(width: 1, color: Colors.black),
                          //     ),
                          //     focusedBorder: UnderlineInputBorder(
                          //       borderSide:
                          //           BorderSide(width: 1, color: Colors.black),
                          //     ),
                          //     labelText: "Date de naissance ",
                          //     labelStyle: TextStyle(color: Colors.black),
                          //   ),
                          //   onTap: () async {
                          //     showMonthPicker(context,
                          //         onSelected: (month, year) {
                          //       print('Selected month: $month, year: $year');
                          //       birthday.text = "$month/$year";
                          //       setState(() {
                          //         this.month = month;
                          //         this.year = year;
                          //       });
                          //     },
                          //         initialSelectedMonth: month,
                          //         initialSelectedYear: year,
                          //         firstEnabledMonth: 1,
                          //         lastEnabledMonth: 12,
                          //         firstYear: 1950,
                          //         lastYear: 2100,
                          //         selectButtonText: 'OK',
                          //         cancelButtonText: 'Cancel',
                          //         highlightColor: kcPrimary,
                          //         textColor: Colors.black,
                          //         contentBackgroundColor: Colors.white,
                          //         dialogBackgroundColor: Colors.grey[200]);
                          //     // DateTime date = DateTime(1900);
                          //     // FocusScope.of(context).requestFocus(FocusNode());
                          //     // date = (await showMonthYearPicker(
                          //     //   context: context,
                          //     //   initialDate: DateTime.now(),
                          //     //   firstDate: DateTime(1900),
                          //     //   lastDate: DateTime(2100),
                          //     //   initialMonthYearPickerMode:
                          //     //       MonthYearPickerMode.year,
                          //     // ))!;
                          //     // birthday.text =
                          //     //     DateFormat("MM/yyyy").format(date);
                          //   },
                          // ),
                          const SizedBox(height: 10),
                          cw.textFormField(
                              controller: email,
                              inputType: TextInputType.emailAddress,
                              isEmail: true,
                              label: "Adresse Email"),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: telephone,
                            keyboardType: TextInputType.number,
                            inputFormatters: [phoneFormatter()],
                            validator: (value) {
                              if (value!.isNotEmpty) {
                                return Validator.validatePhoneNumber(value);
                              } else {
                                return Validator.emptyfield(value);
                              }
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
                              label: RichText(
                                text: const TextSpan(
                                  text: "Numéro de téléphone",
                                  style: TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text: " *",
                                      style: TextStyle(color: Colors.orange),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // textFormField(
                          //   controller: telephone,
                          //   label: "Numéro de téléphone",
                          //   inputType: TextInputType.number,
                          //   isrequired: false,
                          // ),
                          const SizedBox(height: 20),
                          RichText(
                            text: const TextSpan(
                              text: '* ',
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 12,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      "Les champs avec une astérisque sont modifiables",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          Center(
                            child: SizedBox(
                              height: 55,
                              width: size.width * .6,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kcPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(90),
                                  ),
                                ),
                                onPressed: () async {
                                  print("YEAR: ${byear.text}");
                                  if (_formkey.currentState!.validate()) {
                                    setState(() {
                                      isloading = true;
                                    });

                                    await auth
                                        .updateProfile(
                                      id: loggedUser!.id.toString(),
                                      email: email.text,
                                      name: name.text,
                                      lastname: lname.text,
                                      code: code.text,
                                      telephone: telephone.text,
                                      month: index,
                                      year: byear.text == ""
                                          ? null
                                          : int.parse(byear.text),
                                    )
                                        .then((value) {
                                      if (value == true) {
                                        auth
                                            .getUserDetails()
                                            .then((value) async {
                                          if (value != null) {
                                            print("UPDATED USER DATA: $value");
                                            loggedUser = value;
                                            widget.onUpdateCallback(value);
                                            if (mounted) setState(() {});
                                          }
                                        });
                                      } else {
                                        isloading = false;
                                        Navigator.of(context).pop();
                                      }
                                    }).whenComplete(
                                      () => setState(() {
                                        isloading = false;
                                        Navigator.of(context).pop();
                                      }),
                                    );
                                  }
                                },
                                child: const Text(
                                  "CONFIRMER",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: SizedBox(
                              height: 55,
                              width: size.width * .6,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.white,
                                ),
                                onPressed: () async {
                                  code.clear();
                                  name.clear();
                                  lname.clear();
                                  address.clear();
                                  email.clear();
                                  telephone.clear();
                                  // birthday.clear();
                                  bmonth.clear();
                                  byear.clear();
                                },
                                child: const Text(
                                  "EFFACER",
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              isloading ? CustomWidget().loader() : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
