import 'package:flutter/material.dart';

class FAQData {
  final String title;
  // bool expand;
  // Function(bool expand) onPressed;
  Widget info;

  FAQData({required this.title, required this.info});
}

List<FAQData> data = [
  // FAQData(
  //     title: "L'idée",
  //     // info:
  // "A l'heure où le temps de la pause-déjeuner se réduit, Ty-Lunch vous livre dans des contenants réutilisables, des plats gourmands, variés et équilibrés sur votre lieu de travail.\n\nDans la semaine, différents  menus vous sont proposés. Il vous suffit alors  de commander un ou plusieurs de vos repas via l'application "
  // "Ty-Lunch"
  // ", sans frais de livraison.",
  //     expand: false),
  // FAQData(
  //   title: "Le fonctionnement",
  //   expand: false,
  //   // info:
  //   //     "Sur l'application Ty-Lunch vous découvrirez le vendredi les propositions pour la semaine suivante du lundi au vendredi.\nNous vous invitons à anticiper vos commandes pour être assuré de pouvoir savourer le repas de votre choix.  Les plats encore disponibles apparaissent en clair.\n\nVous pouvez commander vos repas de la semaine en une ou plusieurs fois, vous serez livré quotidiennement.\nTy-Lunch est une jeune entreprise. Pour une meilleure fonctionnalité de l'application, des mises à jour occasionnelles seront nécessaires.\n\nVos plats sont conditionnés dans des contenants réutilisables, récupérés au passage suivant."
  // ),
  // FAQData(
  //   title: "La conservation et le réchauffage",
  //   expand: false,
  //   // info:
  //   //     "Les plats sont livrés froids et doivent être maintenus entre 0° et 4° dans un réfrigérateur en attendant leur consommation afin de respecter la chaîne du froid.\n\nIl est recommandé de les consommer dans les 24h.\n\nPour un temps de chauffe plus court, Ty-Lunch vous conseille de réchauffer vos plats dans une assiette. Si vous n'en n'avez pas à disposition, pas de souci, les bols des contenants sont adaptés pour passer au micro-onde !\nDans ce cas, placer le contenant sans son couvercle sous la cloche du micro-onde.\n\nLe temps de réchauffage dépend de la densité du plat et de l'appareil utilisé. N'hésitez pas à ajuster le temps en fonction de votre micro-onde et à mélanger votre repas en court de chauffe afin d'avoir une température homogène.\n\nDurées indicatives pour un réchauffage à puissance maximale (700 à 800W) :\n- Entrées chaudes : 1 min à 1 min 30 s,\n- Plats chauds : 1min 30 à 2 min 30 s."
  // ),
  // FAQData(
  //   title: "Les tarifs",
  //   expand: false,
  //   // info:
  //   //     "Pour votre repas, Ty-Lunch vous propose trois formules :\n- Formule Entrée - Plat à 15,10 € TTC\n- Formule Plat - Dessert à 15,10 € TTC\n- Formule Entrée - Plat - Dessert à 18,40 € TTC\n\nChaque entrée, plat et dessert est aussi disponible à l'unité :\n- Entrée à 3,90 € TTC\n- Plat à 12,00 € TTC\n- Dessert à 3,90 € TTC"
  // ),
  // FAQData(
  //   title: "Les moyens de paiement",
  //   expand: false,
  // ),
  // FAQData(
  //   title: "La commande et la livraison",
  //   expand: false,
  //   // info:
  //   //     "La livraison est offerte !\nChez Ty-Lunch, pas de frais de livraison sur vos commandes passées via l’application !\n\nDisponibilité des plats à la commande :\nLes plats encore disponibles apparaissent en clair sur l'application.\n\nDeux zones de livraison :\n- Pays de Lorient : livraison du mardi au vendredi,\n- Pays de Quimper : livraison du lundi au vendredi. \n\nHoraires de commande par zone :\n- Pays de Lorient : commande la veille avant 18h,\n- Pays de Quimper : commande du jour possible jusqu'à 10h30.\n\nHoraires de livraison :\nLes repas sont livrés entre 9h00 et 12h30 selon les lieux de livraison."
  // ),
  // FAQData(
  //   title: "Les contenants et couverts",
  //   expand: false,
  //   // info:
  // "Nous avons fait le choix de livrer les repas dans des contenants réutilisables fabriqués à Mellac entre Quimper et Lorient.\nIls sont légers, résistants, micro-ondables et agréables au toucher.\n\nComptant sur la responsabilité de chacun d'entre vous, nous n'avons pas mis en place de système de consigne payante. Nous vous les prêtons et les récupérons à notre passage suivant.\n\nPour vos couverts, nous avons eu un coup de cœur pour "
  // "Georgette®"
  // ", fourchette, cuillère et couteau à elle seule. Elle est parfaitement adaptée aux plats préparés pour vous par Ty-Lunch.\nElle est composée uniquement de matière végétale, principalement des algues. Elle est lavable, réutilisable, biodégradable et fabriquée en France !"
  // ),
  // FAQData(
  //   title: "La Petite Histoire de Ty-Lunch",
  //   expand: false,
  //   // info:
  // "C'est la rencontre de deux femmes attachées à la bonne cuisine.\nEn 2021 ces amies épicuriennes décident de créer Ty-Lunch.\n\nCécile, finistérienne, est curieuse et fourmille d'idées novatrices. Sophie, morbihannaise, est chaleureuse, attentive et organisée.\nElles ont travaillé ensemble plusieurs années dans la restauration du midi.\n\nLeur amour commun pour la nourriture goûteuse et saine ainsi qu'une vision globale sur les problématiques du "
  // "bien-manger au quotidien"
  // " les a réunies à nouveau autour d'un concept pensé sur mesure pour vous : Ty-Lunch."
  // ),
  // FAQData(
  //   title: "La production",
  //   expand: false,
  //   // info:
  // "Ty-Lunch réalise une cuisine artisanale aussi bien  traditionnelle que venue d'ailleurs. Ses petits plats sont mijotés "
  // "pour le plus grand plaisir de vos papilles"
  // ".\n\nL'offre est variée et gourmande de l'entrée au dessert. La cuisine végétarienne y tient aussi une belle place !"
  // ),
  // FAQData(
  //     title: "L'approvisionnement",
  //     expand: false,
  //     info:
  //         "Ty-Lunch est situé près de Quimper, région qui regroupe de nombreux producteurs de qualité. Profitons-en !\n\nGrâce à la richesse de notre terroir, Ty-Lunch cuisine principalement à partir de produits frais, de saison, biologiques et favorise nos producteurs finistériens et morbihannais."),

  // FAQData(
  //     title: "Les allergènes",
  //     expand: false,
  //     info:
  //         "Dans notre cuisine nous sommes amenés à travailler différents produits allergènes selon les recettes. Malgré le soin que nous accordons au nettoyage et à la désinfection de nos outils et de nos surfaces de préparation, nos plats sont susceptibles de contenir des traces d'allergènes.\n\nListes des 14 allergènes susceptibles d’être utilisés par Ty-Lunch :\n- Céréales contenant du gluten (blé, seigle, orge, avoine, épeautre, kamut ou leurs souches hybridées) et produits à base de ces céréales,\n- Crustacés et produits à base de crustacés,\n- Œufs et produits à base d’œufs,\n- Poissons et produits à base de poissons,\n- Arachides et produits à base d'arachide,\n- Soja et produits à base de soja,\n- Lait et produits à base de lait (y compris le lactose),\n- Fruits à coques (amande, noisettes, noix, noix de cajou, pécan, macadamia, du brésil, du Queensland, pistaches) et produits à base de ces fruits,\n- Céleri et produits à base de céleri,\n- Moutarde et produits à base de moutarde,\n- Graines de sésame et produits à base de graines de sésame,\n- Anhydride sulfureux et sulfites en concentration de plus de 10 mg/Kg ou 10 mg/L (exprimés en SO2),\n- Lupin et produits à base de lupin,\n- Mollusques et produits à base de mollusques.\nPour toutes demandes d'informations complémentaires concernant les allergènes n'hésitez pas à nous contacter."),
  FAQData(
      title: "Les partenaires",
      // expand: false,
      // onPressed: expanded,
      info: RichText(
        text: const TextSpan(
          text: "",
          style: TextStyle(
              fontSize: 14, color: Colors.black, fontFamily: "CraftRounded"),
          children: [
            TextSpan(
              text: "L’Orée du Bois, notre cuisine\n",
              style: TextStyle(decoration: TextDecoration.underline),
            ),
            TextSpan(
                text:
                    "La cuisine de Ty-Lunch se situe à Ergué-Gabéric à L'Orée du bois.\nL’établissement connu propose la location de salles pour les évènements familiaux : mariages, anniversaires, cousinades…\nA 10 minutes de Quimper, L'Orée du bois dispose aussi d’une salle spécialement conçue pour vos séminaires d’entreprise. La cuisine est préparée par Ty-Lunch.\nL'Orée du bois, c’est aussi un hôtel deux étoiles de 13 chambres au calme à la campagne et à 5 minutes à pied de l’Odet.\n"),
            TextSpan(
              text: "www.oreedubois29.com\n\nDiététicienne, Carole Bilski",
              style: TextStyle(decoration: TextDecoration.underline),
            ),
            TextSpan(
                text:
                    "\nNotre diététicienne est enseignante en BTS diététique au Lycée Chaptal. Carole accompagne Ty-Lunch sur l’équilibre des repas proposés."),
            TextSpan(
              text: "\n\nQuelques-uns de nos fournisseurs privilégiés\n",
              style: TextStyle(decoration: TextDecoration.underline),
            ),
            TextSpan(
                text:
                    "\nMeunier :\nDu grain au pain  - Moulin de Kerveguen - 29500 Ergué-Gabéric - Bio\n\nLégume :\nFerme du Hingaire - 56700 Kervignac\n\nLait :\nLes vachettes gabéricoises - 29500 Ergué-Gabéric\n\nPoisson :\nMoulin Marée - 56100 Lorient\n\nPoulet : \nBlaz du-mañ -  Ferme de Kerskloedenn - 29700 Pluguffan.\n\nContenants :\nNutripack ouest - 29300 Mellac\n\nCouverts :\nGeorgette - Végéplast - 65460 Bazet - Hautes-Pyrénées"),
          ],
        ),
        textAlign: TextAlign.justify,
        // maxLines: expand,
      ))
  // info:
  //     "L’Orée du Bois, notre cuisine\nLa cuisine de Ty-Lunch est située à Ergué-Gabéric dans à L'Orée du bois. \nSitué à l’orée d’un bois à 5 minutes à pieds de l’Odet, l’hôtel propose :\ndes locations de salles pour des évènements de réceptions privées ou séminaires d’entreprise pour lesquelles, du lundi au vendredi, Ty-Lunch peut vous y proposer sa cuisine,\ndes chambres d’hôtel.\nLien vers le site de l’Orée du bois\nDiététicienne, Carole Bilski\nNotre diététicienne est enseignante en BTS diététique au Lycée Chaptal. Carole accompagne Ty-Lunch sur l’équilibre des repas proposés.\nQuelques-uns de nos fournisseurs privilégiés \nMeunier :\nDu grain au pain  - Moulin de Kerveguen - 29500 Ergué-Gabéric - Bio \nLégume :\nFerme du Hingaire - 56700 Kervignac \nLait :\nLes vachettes gabéricoises - 29500 Ergué-Gabéric"),
];
