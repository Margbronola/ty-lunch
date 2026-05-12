import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tylunch/global/widget.dart';
import '../global/color.dart';
import '../global/network.dart';
import '../model/category.dart';
import '../model/menu_details.dart';
import '../viewmodel/category.dart';
import 'menudetail.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({
    super.key,
    required this.category,
    required this.date,
    required this.day,
    required this.menuId,
  });
  final CategorizedData? category;
  final String date;
  final int day;
  final int menuId;

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  static final CategoryViewModel _categoryVM = CategoryViewModel.instance;
  final CustomWidget cw = CustomWidget();
  late String category = "";

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    print("CATEGORY DATA: ${widget.category}");

    return widget.category == null
        ? Container()
        : Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: StreamBuilder<List<CategoryModel>>(
              stream: _categoryVM.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData && !snapshot.hasError) {
                  final List<CategoryModel> result = snapshot.data!;

                  final Iterable<CategoryModel> catData = result.where(
                      (element) =>
                          element.name.contains(widget.category!.name));

                  return ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      if (widget.category!.name.isEmpty) ...{
                        Container()
                      } else ...{
                        Row(
                          children: [
                            if (catData.first.name == "Entrée" ||
                                catData.first.name.contains("entrée") ||
                                catData.first.name.contains("starter") ||
                                catData.first.name.contains("Starter")) ...{
                              SizedBox(
                                width: size.width * .17,
                                child: SvgPicture.asset(
                                  "assets/images/froide-logo.svg",
                                  width: 90,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                              SizedBox(
                                width: size.width * .17,
                                child: SvgPicture.asset(
                                  "assets/images/chaude-logo.svg",
                                  width: 90,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                              const SizedBox(width: 5),
                              // Padding(
                              //   padding:
                              //       const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              //   child: Image.asset(
                              //     "assets/images/entree.png",
                              //     width: size.width * .15,
                              //   ),
                              // ),
                              // Padding(
                              //   padding:
                              //       const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              //   child: Image.asset(
                              //     "assets/images/chaude.png",
                              //     width: size.width * .15,
                              //   ),
                              // ),
                              const Expanded(
                                // width: size.width * .25,
                                child: Text(
                                  "Entrée",
                                  style: TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.w800,
                                    color: kcPrimary,
                                  ),
                                ),
                              )
                            },
                            if (catData.first.name == "Plat" ||
                                catData.first.name.contains("plat") ||
                                catData.first.name.contains("main") ||
                                catData.first.name.contains("Main")) ...{
                              // SizedBox(
                              //   width: size.width * .18,
                              //   child: Padding(
                              //     padding:
                              //         const EdgeInsets.fromLTRB(0, 5, 5, 5),
                              //     child:
                              //         Image.asset("assets/images/plat.png"),
                              //   ),
                              // ),
                              SizedBox(
                                width: size.width * .17,
                                child: SvgPicture.asset(
                                  "assets/images/plat-logo.svg",
                                  width: 90,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Expanded(
                                // width: size.width * .4,
                                child: Text(
                                  " Plat",
                                  style: TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.w800,
                                    color: kcPrimary,
                                  ),
                                ),
                              ),
                            },
                            if (catData.first.name == "Dessert" ||
                                catData.first.name.contains("dessert")) ...{
                              // SizedBox(
                              //   width: size.width * .18,
                              //   child: Padding(
                              //     padding:
                              //         const EdgeInsets.fromLTRB(0, 5, 5, 5),
                              //     child: Image.asset(
                              //         "assets/images/dessert.png"),
                              //   ),
                              // ),
                              SizedBox(
                                width: size.width * .17,
                                child: SvgPicture.asset(
                                  "assets/images/dessert-logo.svg",
                                  width: 90,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Expanded(
                                // width: size.width * .4,
                                child: Text(
                                  " Dessert",
                                  style: TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.w800,
                                    color: kcPrimary,
                                  ),
                                ),
                              ),
                            },
                            SizedBox(
                              width: size.width * .3,
                              child: Text(
                                "${catData.first.price.toStringAsFixed(2)}€",
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: kcPrimary,
                                ),
                              ),
                            ),
                          ],
                        )
                      },
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 285,
                        width: double.infinity,
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, x) {
                            return SizedBox(
                              height: 250,
                              width: 234,
                              child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    constraints: BoxConstraints(
                                      maxHeight: size.height,
                                    ),
                                    context: context,
                                    builder: (_) => BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 0, sigmaY: 0),
                                      child: MenuDetailPage(
                                        prod: widget.category!.products[x],
                                        date: widget.date,
                                        menuId: widget.menuId,
                                        day: widget.day,
                                        categoryId: catData.first,
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      height: 50,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "${widget.category!.products[x].dishName[0].toUpperCase()}${widget.category!.products[x].dishName.substring(1)}",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: kcPrimary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          widget.category!.products[x].vege == 1
                                              ? SvgPicture.asset(
                                                  "assets/icons/vege.svg")
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Stack(
                                        children: [
                                          cw.shimmerLoading(kcPrimary, 234),
                                          Stack(
                                            children: [
                                              if (widget.category!.products[x]
                                                  .photo.isNotEmpty) ...{
                                                Image.network(
                                                  "${Network.url}/storage/${widget.category!.products[x].photo[0].location}",
                                                  fit: BoxFit.cover,
                                                  height: 234,
                                                  width: 234,
                                                  errorBuilder: (_, o, s) =>
                                                      Image.asset(
                                                    "assets/images/placeholder.jpeg",
                                                    fit: BoxFit.cover,
                                                    width: 234,
                                                    height: 234,
                                                  ),
                                                )
                                              } else ...{
                                                Image.asset(
                                                  "assets/images/placeholder.jpeg",
                                                  fit: BoxFit.cover,
                                                  width: 234,
                                                  height: 234,
                                                )
                                              },
                                              if (widget.category!.products[x]
                                                      .stock ==
                                                  0) ...{
                                                Positioned.fill(
                                                  child: Container(
                                                    color: Colors.white
                                                        .withOpacity(.6),
                                                    alignment: Alignment.center,
                                                    child: SvgPicture.asset(
                                                      "assets/icons/Frame 2669.svg",
                                                    ),
                                                  ),
                                                ),
                                              }
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 20),
                          itemCount: widget.category!.products.length,
                        ),
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),
          );
  }
}
