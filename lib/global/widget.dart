import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tylunch/global/cartlength.dart';
import 'package:tylunch/global/color.dart';
import 'package:tylunch/global/validator.dart';
import 'package:tylunch/viewmodel/cart.dart';
import '../model/new_cart_model.dart';

class CustomWidget {
  final CartViewModel _cartViewModel = CartViewModel.instance;

  TextFormField textFormField(
      {TextEditingController? controller,
      TextInputType inputType = TextInputType.text,
      String? label,
      bool isEmail = false,
      bool isfromLogin = false,
      bool isrequired = true,
      bool forCode = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      textCapitalization: forCode == false
          ? TextCapitalization.none
          : TextCapitalization.characters,
      validator: (value) {
        if (isrequired == true) {
          if (isEmail == true) {
            return Validator.validateEmail(value ?? "");
          }
          return Validator.emptyfield(value ?? "");
        }
        return null;
      },
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.black),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.black),
        ),
        label: Row(
          children: [
            Text(
              "$label",
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            forCode == true
                ? SvgPicture.asset("assets/icons/info.svg")
                : Container()
          ],
        ),
      ),
    );
  }

  TextFormField tf1({
    TextEditingController? controller,
    String? name,
    double? size,
    String hintlabel = "",
  }) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        return Validator.emptyfield(value ?? "");
      },
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.black),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.black),
        ),
        hintText: hintlabel,
        labelText: name,
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: size,
        ),
      ),
    );
  }

  RichText title({
    required String t1,
    String? t2,
    required double s1,
    required double s2,
    Color color = kcPrimary,
  }) {
    return RichText(
      text: TextSpan(
        text: t1,
        style: TextStyle(
          fontSize: s1,
          fontFamily: 'CraftRounded',
          color: color,
          fontWeight: FontWeight.w800,
        ),
        children: [
          TextSpan(
            text: t2,
            style: TextStyle(
              fontSize: s2,
            ),
          ),
        ],
      ),
    );
  }

  Text bodytext(
      {String? label, double? size, Color? color, FontWeight? weight}) {
    return Text(
      "$label",
      style: TextStyle(
        fontSize: size,
        fontFamily: 'CraftRounded',
        color: color,
        fontWeight: weight,
      ),
    );
  }

  placeholder() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: SizedBox(
        height: 150,
        child: Image.asset(
          "assets/images/placeholder.jpeg",
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  header() {
    return Stack(
      children: [
        Image.asset(
          'assets/images/ty2.png',
          fit: BoxFit.fitWidth,
          width: double.maxFinite,
        ),
        Positioned(
          top: 50,
          left: 40,
          child: SizedBox(
            width: 165,
            child: Image.asset('assets/icons/Frame3.png', fit: BoxFit.fitWidth),
          ),
        ),
      ],
    );
  }

  addedtocart() {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        width: 300,
        height: 230,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            )),
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset('assets/images/Vector (1).png'),
                Positioned(
                  top: 10,
                  left: 110,
                  child: Image.asset('assets/images/Frame (1).png'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Votre commande",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: kcPrimary,
              ),
            ),
            const Text(
              "a été ajoutée au panier!",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  loader() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaY: 4, sigmaX: 4),
      child: Container(
        color: Colors.white.withOpacity(0.4),
        child: const Center(
            child: CircularProgressIndicator(
          color: kcPrimaryLight,
        )),
      ),
    );
  }

  divider({required double num}) {
    return DottedBorder(
      options: CustomPathDottedBorderOptions(
        color: Color.fromARGB(255, 139, 139, 139),
        dashPattern: [5, num],
        customPath: (size) {
          return Path()
            ..moveTo(0, 5)
            ..lineTo(size.width, 5);
        },
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Container(),
      ),
    );
  }

  Widget cartQty({Function()? onPressed}) => StreamBuilder<List<NewCartModel>>(
        stream: _cartViewModel.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData && !snapshot.hasError) {
            if (snapshot.data!.isNotEmpty) {
              final List<NewCartModel> result = snapshot.data!;
              final int cartLength = getCartLength().getLength(result);
              return Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  "$cartLength",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              );
            }
          }
          return Container();
        },
      );

  Widget shimmerLoading(
    Color base,
    double height, {
    double width = double.maxFinite,
  }) =>
      Center(
        child: Shimmer.fromColors(
          enabled: true,
          baseColor: base,
          highlightColor: base.withOpacity(0.5),
          child: Container(
            width: width,
            height: height,
            color: base.withOpacity(.5),
          ),
        ),
      );
}
