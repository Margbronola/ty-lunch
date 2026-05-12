import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../global/color.dart';

class TyLunchPage extends StatefulWidget {
  const TyLunchPage({super.key});

  @override
  State<TyLunchPage> createState() => _TyLunchPageState();
}

class _TyLunchPageState extends State<TyLunchPage> {
  bool expand = false;
  bool expand1 = false;
  bool expand2 = false;
  bool expand3 = false;
  bool expand4 = false;
  bool expand5 = false;
  bool expand6 = false;
  bool expand7 = false;
  bool expand8 = false;
  bool expand9 = false;
  bool expand10 = false;
  bool expand11 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SvgPicture.asset(
                  "assets/images/circ 5.svg",
                  color: secondaryColor,
                ),
                Positioned(
                  top: 20,
                  left: 20,
                  child: SvgPicture.asset("assets/icons/Ty-Lunch.svg"),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Comment ça marche",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: kcPrimary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "02 98 55 56 15\naccueil@ty-lunch.fr",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 30),
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              "L'idée",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: kcPrimary),
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  expand = !expand;
                                });
                              },
                              child: Image.asset("assets/icons/logo5.png",
                                  width: 40)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                          "A l'heure où le temps de la pause-déjeuner se réduit, Ty-Lunch vous livre dans des contenants réutilisables, des plats gourmands, variés et équilibrés sur votre lieu de travail.\n\nDans la semaine, différents  menus vous sont proposés. Il vous suffit alors  de commander un ou plusieurs de vos repas via l'application "
                          "Ty-Lunch"
                          ", sans frais de livraison.",
                          textAlign: TextAlign.justify,
                          maxLines: expand == false ? 2 : null)
                    ],
                  ),
                  Container(
                      color: Colors.grey.withOpacity(0.2),
                      height: 2,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 20)),
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              "Le fonctionnement",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: kcPrimary),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                expand1 = !expand1;
                              });
                            },
                            child: Image.asset("assets/icons/logo5.png",
                                width: 40),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                          "Sur l'application Ty-Lunch vous découvrirez le vendredi les propositions pour la semaine suivante du lundi au vendredi.\nNous vous invitons à anticiper vos commandes pour être assuré de pouvoir savourer le repas de votre choix.  Les plats encore disponibles apparaissent en clair.\n\nVous pouvez commander vos repas de la semaine en une ou plusieurs fois, vous serez livré quotidiennement.\nTy-Lunch est une jeune entreprise. Pour une meilleure fonctionnalité de l'application, des mises à jour occasionnelles seront nécessaires.\n\nVos plats sont conditionnés dans des contenants réutilisables, récupérés au passage suivant.",
                          textAlign: TextAlign.justify,
                          maxLines: expand1 == false ? 2 : null)
                    ],
                  ),
                  Container(
                      color: Colors.grey.withOpacity(0.2),
                      height: 2,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 20)),
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              "La conservation et le réchauffage",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: kcPrimary),
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  expand2 = !expand2;
                                });
                              },
                              child: Image.asset("assets/icons/logo5.png",
                                  width: 40)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      RichText(
                          text: const TextSpan(
                            text: "",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontFamily: "CraftRounded"),
                            children: [
                              TextSpan(
                                  text:
                                      "Les plats sont livrés froids et doivent être maintenus entre 0° et 4° dans un réfrigérateur en attendant leur consommation afin de respecter la chaîne du froid.\n\nIl est recommandé de les consommer dans les 24h.\n\nPour un temps de chauffe plus court, Ty-Lunch vous conseille de réchauffer vos plats dans une assiette. Si vous n'en n'avez pas à disposition, pas de souci, les bols des contenants sont adaptés pour passer au micro-onde !\nDans ce cas, placer le contenant"),
                              TextSpan(
                                  text: " sans son couvercle ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                              TextSpan(
                                  text:
                                      "sous la cloche du micro-onde.\n\nLe temps de réchauffage dépend de la densité du plat et de l'appareil utilisé. N'hésitez pas à ajuster le temps en fonction de votre micro-onde et à mélanger votre repas en cours de chauffe afin d'avoir une température homogène.\n\nDurées indicatives pour un réchauffage à puissance maximale (700 à 800W) :\n- Entrées chaudes : 1 min à 1 min 30 s,\n- Plats chauds : 1min 30 à 2 min 30 s."),
                            ],
                          ),
                          textAlign: TextAlign.justify,
                          maxLines: expand2 == false ? 2 : null),
                    ],
                  ),
                  Container(
                      color: Colors.grey.withOpacity(0.2),
                      height: 2,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 20)),
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              "Les tarifs",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: kcPrimary),
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  expand3 = !expand3;
                                });
                              },
                              child: Image.asset("assets/icons/logo5.png",
                                  width: 40)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                          "Pour votre repas, Ty-Lunch vous propose trois formules :\n- Formule Entrée - Plat à 15.30 € TTC\n- Formule Plat - Dessert à 14 € TTC\n- Formule Entrée - Plat - Dessert à 17 € TTC\n\nChaque entrée, plat et dessert est aussi disponible à l'unité :\n- Entrée à 4 € TTC\n- Plat à 12 € TTC\n- Dessert à 2.60 € TTC",
                          textAlign: TextAlign.justify,
                          maxLines: expand3 == false ? 2 : null)
                    ],
                  ),
                  Container(
                      color: Colors.grey.withOpacity(0.2),
                      height: 2,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 20)),
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              "Les moyens de paiement",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: kcPrimary,
                              ),
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  expand4 = !expand4;
                                });
                              },
                              child: Image.asset("assets/icons/logo5.png",
                                  width: 40))
                        ],
                      ),
                      const SizedBox(height: 10),
                      RichText(
                          text: const TextSpan(
                            text: "",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontFamily: "CraftRounded"),
                            children: [
                              TextSpan(
                                  text:
                                      "Le paiement s’effectue via l’application par carte bancaire ou titres-restaurant dématérialisés.\n\n"),
                              TextSpan(
                                  text: "Banque",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  text:
                                      " :\nVous pouvez choisir entre CD, Visa ou Mastercard.\n\n"),
                              TextSpan(
                                  text: "Crédits",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  text:
                                      " :\nVous pouvez nous transmettre vos titres-restaurant papier afin que l’on crédite votre compte.\n\nPour utiliser votre crédit, votre panier doit être inférieur ou égal :\n  -  au montant de crédit disponible,\net \n  -  à la limite du plafond journalier défini par la législation.\n\n"),
                              TextSpan(
                                  text: "Titres-restaurant dématérialisés",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  text:
                                      " :\nAu moment du paiement, vous pouvez utiliser votre carte titre-restaurant Bimpli, Sodexo ou Updéjeuner, dans la limite du plafond journalier défini par la législation."),
                            ],
                          ),
                          textAlign: TextAlign.justify,
                          maxLines: expand4 == false ? 2 : null),
                    ],
                  ),
                  Container(
                      color: Colors.grey.withOpacity(0.2),
                      height: 2,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 20)),
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              "La commande et la livraison",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: kcPrimary,
                              ),
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  expand5 = !expand5;
                                });
                              },
                              child: Image.asset("assets/icons/logo5.png",
                                  width: 40)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                          "La livraison est offerte !\nChez Ty-Lunch, pas de frais de livraison sur vos commandes passées via l’application !\n\nDisponibilité des plats à la commande :\nLes plats encore disponibles apparaissent en clair sur l'application.\n\nDeux zones de livraison :\n- Pays de Lorient : livraison du mardi au vendredi,\n- Pays de Quimper : livraison du lundi au vendredi. \n\nHoraires de commande par zone :\n- Pays de Lorient : commande la veille avant 18h,\n- Pays de Quimper : commande du jour possible jusqu'à 10h30.\n\nHoraires de livraison :\nLes repas sont livrés entre 9h00 et 12h30 selon les lieux de livraison.",
                          textAlign: TextAlign.justify,
                          maxLines: expand5 == false ? 2 : null)
                    ],
                  ),
                  Container(
                    color: Colors.grey.withOpacity(0.2),
                    height: 2,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                  ),
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              "Les contenants et couverts",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: kcPrimary),
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  expand6 = !expand6;
                                });
                              },
                              child: Image.asset("assets/icons/logo5.png",
                                  width: 40)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                          "Nous avons fait le choix de livrer les repas dans des contenants réutilisables fabriqués à Mellac entre Quimper et Lorient.\nIls sont légers, résistants, micro-ondables et agréables au toucher.\n\nComptant sur la responsabilité de chacun d'entre vous, nous n'avons pas mis en place de système de consigne payante. Nous vous les prêtons et les récupérons à notre passage suivant.\n\nPour vos couverts, nous avons eu un coup de cœur pour "
                          "Georgette®"
                          ", fourchette, cuillère et couteau à elle seule. Elle est parfaitement adaptée aux plats préparés pour vous par Ty-Lunch.\nElle est composée uniquement de matière végétale, principalement des algues. Elle est lavable, réutilisable, biodégradable et fabriquée en France !",
                          textAlign: TextAlign.justify,
                          maxLines: expand6 == false ? 2 : null)
                    ],
                  ),
                  Container(
                    color: Colors.grey.withOpacity(0.2),
                    height: 2,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                  ),
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              "La Petite Histoire de Ty-Lunch",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: kcPrimary),
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  expand7 = !expand7;
                                });
                              },
                              child: Image.asset("assets/icons/logo5.png",
                                  width: 40)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                          "C'est la rencontre de deux femmes attachées à la bonne cuisine.\nEn 2021 ces amies épicuriennes décident de créer Ty-Lunch.\n\nCécile, finistérienne, est curieuse et fourmille d'idées novatrices. Sophie, morbihannaise, est chaleureuse, attentive et organisée.\nElles ont travaillé ensemble plusieurs années dans la restauration du midi.\n\nLeur amour commun pour la nourriture goûteuse et saine ainsi qu'une vision globale sur les problématiques du "
                          "bien-manger au quotidien"
                          " les a réunies à nouveau autour d'un concept pensé sur mesure pour vous : Ty-Lunch.",
                          textAlign: TextAlign.justify,
                          maxLines: expand7 == false ? 2 : null)
                    ],
                  ),
                  Container(
                    color: Colors.grey.withOpacity(0.2),
                    height: 2,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                  ),
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              "La production",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: kcPrimary),
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  expand8 = !expand8;
                                });
                              },
                              child: Image.asset("assets/icons/logo5.png",
                                  width: 40)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: const TextSpan(
                            text:
                                "Ty-Lunch réalise une cuisine artisanale aussi bien  traditionnelle que venue d'ailleurs. Ses petits plats sont mijotés "
                                "pour le plus grand plaisir de vos papilles"
                                ".\n\nL'offre est variée et gourmande de l'entrée au dessert. La cuisine végétarienne y tient aussi une belle place !",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontFamily: "CraftRounded"),
                            children: [
                              TextSpan(
                                  text:
                                      "\n\nNotre cuisine se situe 6 rue Albert Stéphan, ZI du Petit Guélen, 29000 Quimper.",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                            ]),
                        textAlign: TextAlign.justify,
                        maxLines: expand8 == false ? 2 : null,
                      ),
                    ],
                  ),
                  Container(
                    color: Colors.grey.withOpacity(0.2),
                    height: 2,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                  ),
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              "L'approvisionnement",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: kcPrimary),
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  expand9 = !expand9;
                                });
                              },
                              child: Image.asset("assets/icons/logo5.png",
                                  width: 40)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                          "Ty-Lunch est situé près de Quimper, région qui regroupe de nombreux producteurs de qualité. Profitons-en !\n\nGrâce à la richesse de notre terroir, Ty-Lunch cuisine principalement à partir de produits frais, de saison, biologiques et favorise nos producteurs finistériens et morbihannais.",
                          textAlign: TextAlign.justify,
                          maxLines: expand9 == false ? 2 : null)
                    ],
                  ),
                  Container(
                    color: Colors.grey.withOpacity(0.2),
                    height: 2,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                  ),
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              "Les allergènes",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: kcPrimary,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                expand10 = !expand10;
                              });
                            },
                            child: Image.asset("assets/icons/logo5.png",
                                width: 40),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: const TextSpan(
                          text:
                              "Dans notre cuisine nous sommes amenés à travailler différents produits allergènes selon les recettes. Malgré le soin que nous accordons au nettoyage et à la désinfection de nos outils et de nos surfaces de préparation, nos plats sont susceptibles de contenir des traces d'allergènes. ",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: "CraftRounded"),
                          children: [
                            TextSpan(
                                text:
                                    "\n\nSi vous êtes sujet à des allergies graves, nous vous conseillons de commander vos repas dans des contenants à usage unique.",
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            TextSpan(
                                text:
                                    "\n\nListes des 14 allergènes susceptibles d’être utilisés par Ty-Lunch :\n- Céréales contenant du "),
                            TextSpan(
                                text: "gluten",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline)),
                            TextSpan(
                                text:
                                    " (blé, seigle, orge, avoine, épeautre, kamut ou leurs souches hybridées) et produits à base de ces céréales,\n- "),
                            TextSpan(
                                text: "Crustacés",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline)),
                            TextSpan(
                                text: " et produits à base de crustacés,\n- "),
                            TextSpan(
                                text: "Œufs",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline)),
                            TextSpan(text: " et produits à base d’œufs,\n- "),
                            TextSpan(
                                text: "Poissons",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline)),
                            TextSpan(
                                text: " et produits à base de poissons,\n- "),
                            TextSpan(
                                text: "Arachides",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline)),
                            TextSpan(
                                text: " et produits à base d'arachide,\n- "),
                            TextSpan(
                                text: "Soja",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline)),
                            TextSpan(text: " et produits à base de soja,\n- "),
                            TextSpan(
                                text: "Lait",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline)),
                            TextSpan(
                                text:
                                    " et produits à base de lait (y compris le lactose),\n- "),
                            TextSpan(
                                text: "Fruits à coques",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline)),
                            TextSpan(
                                text:
                                    " (amande, noisettes, noix, noix de cajou, pécan, macadamia, du brésil, du Queensland, pistaches) et produits à base de ces fruits,\n- "),
                            TextSpan(
                                text: "Céleri",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline)),
                            TextSpan(
                                text: " et produits à base de céleri,\n- "),
                            TextSpan(
                                text: "Moutarde",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline)),
                            TextSpan(
                                text:
                                    " et produits à base de moutarde,\n- Graines de "),
                            TextSpan(
                                text: "sésame",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline)),
                            TextSpan(
                                text:
                                    " et produits à base de graines de sésame,\n- Anhydride "),
                            TextSpan(
                                text: "sulfureux",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline)),
                            TextSpan(text: " et "),
                            TextSpan(
                                text: "sulfites",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline)),
                            TextSpan(
                                text:
                                    " en concentration de plus de 10 mg/Kg ou 10 mg/L (exprimés en SO2),\n- "),
                            TextSpan(
                                text: "Lupin",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline)),
                            TextSpan(text: " et produits à base de lupin,\n- "),
                            TextSpan(
                                text: "Mollusques",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline)),
                            TextSpan(
                                text:
                                    " et produits à base de mollusques.\nPour toutes demandes d'informations complémentaires concernant les allergènes n'hésitez pas à nous contacter."),
                          ],
                        ),
                        textAlign: TextAlign.justify,
                        maxLines: expand10 == false ? 2 : null,
                      ),
                    ],
                  ),
                  Container(
                    color: Colors.grey.withOpacity(0.2),
                    height: 2,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                  ),
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              "Les partenaires",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: kcPrimary,
                              ),
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  expand11 = !expand11;
                                });
                              },
                              child: Image.asset("assets/icons/logo5.png",
                                  width: 40)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: const TextSpan(
                          text: "",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: "CraftRounded"),
                          children: [
                            TextSpan(
                                text:
                                    "L’Orée du Bois, notre première cuisine, nos premiers pas.\n",
                                style: TextStyle(
                                    decoration: TextDecoration.underline)),
                            TextSpan(
                                text:
                                    "L’établissement connu propose la location de salles pour les évènements familiaux : mariages, anniversaires, cousinades…\nA 10 minutes de Quimper, L'Orée du bois dispose aussi d’une salle spécialement conçue pour vos séminaires d’entreprise. La cuisine est préparée par Ty-Lunch.\nL'Orée du bois, c’est aussi un hôtel deux étoiles de 13 chambres au calme à la campagne et à 5 minutes à pied de l’Odet.\n"),
                            TextSpan(
                                text:
                                    "www.oreedubois29.com\n\nDiététicienne, Carole Bilski",
                                style: TextStyle(
                                    decoration: TextDecoration.underline)),
                            TextSpan(
                                text:
                                    "\nNotre diététicienne est enseignante en BTS diététique au Lycée Chaptal. Carole accompagne Ty-Lunch sur l’équilibre des repas proposés."),
                            TextSpan(
                                text:
                                    "\n\nQuelques-uns de nos fournisseurs privilégiés\n",
                                style: TextStyle(
                                    decoration: TextDecoration.underline)),
                            TextSpan(
                                text:
                                    "\nMeunier :\nDu grain au pain  - Moulin de Kerveguen - 29500 Ergué-Gabéric - Bio\n\nLégume :\nFerme du Hingaire - 56700 Kervignac\n\nLait :\nLes vachettes gabéricoises - 29500 Ergué-Gabéric\n\nPoisson :\nMoulin Marée - 56100 Lorient\n\nPoulet : \nBlaz du-mañ -  Ferme de Kerskloedenn - 29700 Pluguffan.\n\nContenants :\nNutripack ouest - 29300 Mellac\n\nCouverts :\nGeorgette® - Végéplast - 65460 Bazet - Hautes-Pyrénées"),
                          ],
                        ),
                        textAlign: TextAlign.justify,
                        maxLines: expand11 == false ? 2 : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


// SizedBox(
                  //   child: ListView.separated(
                  //     shrinkWrap: true,
                  //     physics: const NeverScrollableScrollPhysics(),
                  //     itemBuilder: (C, i) {
                  //       return Column(
                  //         children: [
                  //           Row(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             children: [
                  //               Expanded(
                  //                 child: Text(
                  //                   data[i].title,
                  //                   style: const TextStyle(
                  //                     fontSize: 24,
                  //                     fontWeight: FontWeight.w600,
                  //                     color: kcPrimary,
                  //                   ),
                  //                 ),
                  //               ),
                  //               GestureDetector(
                  //                 onTap: () {
                  //                   setState(() {
                  //                     data[i].expand = !data[i].expand;
                  //                   });
                  //                 },
                  //                 child: Image.asset(
                  //                   "assets/icons/logo5.png",
                  //                   width: 40,
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //           const SizedBox(height: 10),
                  //           Text(
                  //             data[i].info,
                  //             style: const TextStyle(fontSize: 14),
                  //             textAlign: TextAlign.justify,
                  //             maxLines: data[i].expand == false ? 2 : null,
                  //           )
                  //         ],
                  //       );
                  //     },
                  //     separatorBuilder: (_, __) => Container(
                  //       color: Colors.grey.withOpacity(0.2),
                  //       height: 2,
                  //       width: double.infinity,
                  //       margin: const EdgeInsets.symmetric(vertical: 20),
                  //     ),
                  //     itemCount: data.length,
                  //   ),
                  // ),
                  // const SizedBox(height: 5),