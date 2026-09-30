import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_14/about_us_page.dart';
import 'package:flutter_application_14/bus_detail_page.dart';
import 'package:flutter_application_14/bus_list_page.dart';
import 'package:flutter_application_14/careers_page.dart';
import 'package:flutter_application_14/complaints_page.dart';
import 'package:flutter_application_14/news_page.dart';
import 'package:flutter_application_14/policy_page.dart';
import 'package:flutter_application_14/seat_booking_page.dart';
import 'package:flutter_application_14/services_page.dart';
import 'package:flutter_application_14/services/search_service.dart';
import 'package:flutter_application_14/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


 

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
   int selectedIndex = 0; 
   int selectedBox = -1;

  final TextEditingController originController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController returnDateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    originController.dispose();
    destinationController.dispose();
    dateController.dispose();
    returnDateController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void searchBuses() {
    final String origin = originController.text.trim();
    final String destination = destinationController.text.trim();
    final String date = dateController.text.trim();
    final String returnDate = returnDateController.text.trim();

    SearchService.instance.saveSearch(
      origin: origin,
      destination: destination,
      date: date,
      returnDate: returnDate,
    );

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => BusListPage(
          origin: origin,
          destination: destination,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Row(
    children: const [
      Text(
        "Shaheen Express",
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(width: 10),
      Text(
        "Some Other Text",
        style: TextStyle(fontSize: 14, color: Colors.white70),
      ),
    ],
  ),
  actions: [
    TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/buslistpage');
      },
      child: const Text(
        "buslistpage",
        style: TextStyle(color: Colors.white),
      ),
    ),
  ],
),

      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text(
                "Shaheen Express",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SeatBooking()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.directions_bus),
              title: const Text("Buslistpage"),
              onTap: () {
               Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BusListPage()),
                );
              },
            ),
             ListTile(
              leading: const Icon(Icons.directions_bus),
              title: const Text("Busdetailpage"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BusDetailPage()),
                );
              },
            ),


            ListTile(
              leading: const Icon(Icons.miscellaneous_services),
              title: const Text("Services"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ServicePage()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.article),
              title: const Text("News"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewsPage()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.work),
              title: const Text("Careers"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CareersPage()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("About"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.policy),
              title: const Text("Policy"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PolicyPage()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.report_problem),
              title: const Text("Complaint"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ComplaintPage()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
          ],
        ),
      ),

     body: 
     Container(
  width: double.infinity,
  height: double.infinity,
  decoration: const BoxDecoration(
    image: DecorationImage(
      image: AssetImage("assets/shaheenexpress.png"),
      fit: BoxFit.cover,
      
    ),
  ),
  child:  Stack(
  children: [
    
    Positioned.fill(
      child: Image.asset(
        "assets/shaheenexpress.png",
        fit: BoxFit.cover,
      ),
    ),

    // Dark overlay
    Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.3),
      ),
    ),

    SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            color: Colors.green.withValues(alpha: 0.8),
            child: SizedBox(
              height: 50,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Stack(
                    children: [
                      const Row(
  children: [
    Icon(Icons.phone, color: Colors.white),
    SizedBox(width: 5),

    Text(
      'Call us now',
      style: TextStyle(
        fontSize: 20,
        color: Colors.white,
      ),
    ),

    SizedBox(width: 10),
                         Text(
      '0033445566',
      style: TextStyle(color: Colors.white),
    ),
     Spacer(),

    Text(
      "Req #",
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
    ),
     SizedBox(width: 10),
     
      SizedBox(
      width: 120,
      height: 40,
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            
          ),
        ),
      ),
    ),

SizedBox(
  
  width: 120,
  height: 40,
child: TextField(
  
  decoration:InputDecoration(
    filled: true,
    fillColor:Colors.blueAccent,
    hintText: "check refund status",hintStyle: TextStyle(fontSize: 8),
    
  ),
),
),
       SizedBox(width: 10,),
          Text("sig In",style: TextStyle(fontSize: 18),),


                        ],
                      ),
                      Align(
                        alignment: Alignment(
                          0,
                          1 - (_controller.value * 2),
                        ),
                        child: const Text(
                          "SHAHEEN EXPRESS",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "WELCOME TO SHAHEEN EXPRESS",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 70,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 50),

        SizedBox(
  height: 400,
  child: CarouselSlider(
    options: CarouselOptions(
      height: 500,
      autoPlay: true,
      enlargeCenterPage: false,
      viewportFraction: 0.95,
      autoPlayInterval: const Duration(seconds: 3),
    ),
    items: [
      Container(
        width: 400,
        height: 600,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: const DecorationImage(
            image: AssetImage("assets/islamabad.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),

      Container(
        width: 400,
        height: 600,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: const DecorationImage(
            image: AssetImage("assets/Lahore.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Container(
        width: 400,
        height: 600,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: const DecorationImage(
            image: AssetImage("assets/multan.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Container(
        width: 400,
        height: 600,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: const DecorationImage(
            image: AssetImage("assets/quaidazam.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    ],
  ),
),
          const SizedBox(height: 100,),
          
const SizedBox(height: 30),

const SizedBox(height: 30),

const SizedBox(height: 30),

const SizedBox(height: 30),

const SizedBox(height: 30),

Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: Row(
    children: [

    
    Expanded( child: TextField( controller: originController, decoration: InputDecoration( labelText: "Origin", border: OutlineInputBorder(), prefixIcon: Icon(Icons.location_on), ), ), ), const SizedBox(width: 15), Expanded( child: TextField( controller: destinationController, decoration: InputDecoration( labelText: "Destination", border: OutlineInputBorder(), prefixIcon: Icon(Icons.location_city), ), ), ),
      const SizedBox(width: 15),

    Expanded( child: TextField( controller: dateController, decoration: InputDecoration( labelText: "Date", border: OutlineInputBorder(), prefixIcon: Icon(Icons.location_city), ), ), ),
    const SizedBox(width: 15),
    Expanded( child: TextField( controller: returnDateController, decoration: InputDecoration( labelText: "Return Date", border: OutlineInputBorder(), prefixIcon: Icon(Icons.location_city), ), ), ),
    const SizedBox(width: 15),
      SizedBox(
        height: 56,
        width: 140,
        
        child: ElevatedButton.icon(
          onPressed: searchBuses,
          icon: const Icon(Icons.search),
          label: const Text(
            "Search",
            style: TextStyle(fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.white,
            
          ),
        ),
      ),
    ],
  ),
),

SizedBox(height: 15),

Row(
  children: [

    
   Expanded(
  child: Container(
    height: 700,
    padding: const EdgeInsets.all(100),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: "Manage your tickets ",
                style: TextStyle(color: Colors.white),
              ),
              TextSpan(
                text: "hassle -",
                style: TextStyle(color: Colors.yellow),
              ),
            ],
          ),
        ),

        const SizedBox(height: 5),
         
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 45,
            ),
            children: [
              TextSpan(
                text: "with ",
                style: TextStyle(color: Colors.white),
              ),
              TextSpan(
                text: "swift refund",
                style: TextStyle(color: Colors.yellow),
              ),
            ],
          ),
        ),

        const SizedBox(height: 5),

        const Text(
          "Policies!",
          style: TextStyle(
            fontSize: 40,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 5),

        const Text(
          "With the modernized tracking facility, know where your bus is located. Stay posted with real-time information.",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    ),
  ),
),
  
    Expanded(
      child: SizedBox(
        height: 500,
        child: Image.asset(
          "assets/shaheen222.png",
          fit: BoxFit.contain,
        ),
      ), 
    ),
  ],
),
SizedBox(height: 130,),
Container(
  width: double.infinity,
  alignment: Alignment.centerLeft,
  child: Padding(
  padding: const EdgeInsets.only(left: 50),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "At your service with quality travel!",
        style: TextStyle(color: Colors.yellow,fontSize: 20),
      ),

     RichText(
  text: const TextSpan(
    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
    children: [
      TextSpan(
        text: "Avail the executive ",
        style: TextStyle(color: Colors.white),
      ),
      TextSpan(
        text: "budget-friendly ",
        style: TextStyle(color: Colors.yellow),
      ),
      TextSpan(
        text: "deals\n",
        style: TextStyle(color: Colors.white),
      ),

      TextSpan(
        text: "at the ",
        style: TextStyle(color: Colors.white,fontSize: 31), 
      ),
      TextSpan(
        text: "premium platform of Shaheen Express",
        style: TextStyle(color: Colors.yellow,fontSize: 32),
      ),
    ],
  ),
),
    ],
  ),
),
),
SizedBox(height: 100,),
Padding(
  padding: const EdgeInsets.all(20),
  child: Row(
    children: [
      Expanded(
        child:Container(
  height: 270,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: const [
      BoxShadow(
        color: Colors.white,
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child:  ClipRRect(
  borderRadius: BorderRadius.circular(12),
  child: Image.asset(
    "assets/shaheen1.png",
    width: 220,
    height: 250,
    fit: BoxFit.contain,
  ),
),
),
      ),

      const SizedBox(width: 15),
      Expanded(
        child:Container(
  height: 270,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: const [
      BoxShadow(
        color: Colors.white,
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(
        "assets/shaheen2.png",
        height: 230,
        width: 250,
        fit: BoxFit.cover,
      ),
      const SizedBox(height: 10),
      const Text(
        "",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
)
      ),

      const SizedBox(width: 15),

      
      Expanded(
        child:Container(
  height: 270,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: const [
      BoxShadow(
        color: Colors.white,
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(
        "assets/shaheen3.png",
        height: 230,
        width:  255,
        fit: BoxFit.cover,
      ),
      const SizedBox(height: 10),
      const Text(
        "",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
)
      ),

      const SizedBox(width: 15),

      
      Expanded(
        child: Container(
  height: 270,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: const [
      BoxShadow(
        color: Colors.white,
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(
        "assets/shaheen4.png",
        height: 230,
        width:  255,
        fit: BoxFit.cover,
      ),
      const SizedBox(height: 10),
      const Text(
        "",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
)
      ),

    ],
  ),
),
Padding(
  padding: const EdgeInsets.only(right:800),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "How does it monitor?",
        style: TextStyle(
          color: Colors.yellow,
          fontSize: 20,
        ),
      ),

      RichText(
        text: const TextSpan(
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(
              text: "Book your tickets with ",
              style: TextStyle(color: Colors.white),
            ),
            TextSpan(
              text: "secure\n",
              style: TextStyle(color: Colors.yellow),
            ),

            TextSpan(
              text: "Payment method ",
              style: TextStyle(color: Colors.yellow),
            ),
                        TextSpan(
              text: "and swift refund\n",
              style: TextStyle(
                color: Colors.white,
                fontSize: 31,
              ),
            ),

            TextSpan(
              text: "Policies.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
              ),
            ),
          ],
        ),
        
      ),
    ],
  ),
),
SizedBox(height: 15,),
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: Row(
    children: List.generate(4, (index) {
      List<IconData> icons = [
        Icons.health_and_safety,
        Icons.security,
        Icons.support_agent,
        Icons.assignment_return,
      ];

      List<String> titles = [
        "Health & Safety",
        "100% Secure",
        "24/7 Support",
        "Refund Policy",
      ];

      List<String> descriptions = [
        "Your secure and safe travel is our priority. We ensure a healthy and comfortable journey for every passenger.",
        "Book with confidence through Easypaisa, JazzCash, Alfalah MPG and other secure payment methods.",
        "Our dedicated support team is available 24/7 to assist you with all your travel queries.",
        "Easy refund and exchange policy designed for your convenience and satisfaction.",
      ];

      return Expanded(
        child: GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 5),
            padding: const EdgeInsets.all(18),
            height: 300,
           decoration: BoxDecoration(
  color: Colors.black,
  borderRadius: BorderRadius.circular(10),
  border: Border.all(
    color: selectedIndex == index
        ? Colors.yellow
        : Colors.transparent,
    width: 4,
  ),
  boxShadow: const [
    BoxShadow(
      color: Colors.black26,
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ],
),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icons[index],
                  color: Colors.yellow,
                  size: 42,
                ),
                const SizedBox(height: 20),
                Text(
                  titles[index],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: Text(
                    descriptions[index],
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }),
  ),
),
const SizedBox(height: 40),
Padding(
  padding: const EdgeInsets.symmetric(vertical: 40),
  child: Column(
    children: [

      
      const Text(
        "Our Blog",
        style: TextStyle(
          color: Colors.yellow,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(height: 10),

      
      RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(
              text: "What ",
              style: TextStyle(color: Colors.white),
            ),
            TextSpan(
              text: "Our ",
              style: TextStyle(color: Colors.yellow),
            ),
            TextSpan(
              text: "Travelers ",
              style: TextStyle(color: Colors.yellow),
            ),
            TextSpan(
              text: "Are ",
              style: TextStyle(color: Colors.white),
            ),
            TextSpan(
              text: "Saying!",
              style: TextStyle(color: Colors.yellow),
            ),
          ],
        ),
      ),
    ],
  ),
),
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
  child: Row(
    children: [
      Expanded(
        child: Container(
          height: 370,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: const DecorationImage(
              image: AssetImage("assets/shaheenexpress1.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),

      Expanded(
        child: Container(
          height: 370,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: const DecorationImage(
              image: AssetImage("assets/shaheenexpress2.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),

      Expanded(
        child: Container(
          height: 370,
          margin: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: const DecorationImage(
              image: AssetImage("assets/shaheenexpress3.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    ],
  ),
),
SizedBox(height: 30,),
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  child: Row(
    children: List.generate(3, (index) {
      List<String> titles = [
        "Shaheen Express Prestige (FMP) Reservations",
        "With Shaheen Express, Indulge in Luxurious Comfort with Premium Buses",
        "Shaheen Express - The Forechoice to Meet Your Transportation, Logistics and Residential Needs!",
      ];

      List<String> descriptions = [
        "With the customized travel plans, we believe in crafting the best journey experience for every passenger.",
        "We serve our privileged customers with the finest services crafted for comfort, safety and convenience.",
        "Let the travel magic unravel! Shaheen Express stands firm at providing world-class transport services.",
      ];

      return Expanded(
        child: GestureDetector(
          onTap: () {
            setState(() {
              selectedBox = index;
            });
          },
          child: Container(
            height: 250,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade700),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titles[index],
                  style: TextStyle(
                    color: selectedBox == index
                        ? Colors.yellow
                        : Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  descriptions[index],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }),
  ),
),
SizedBox(height: 30,),
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  child: CarouselSlider(
    options: CarouselOptions(
      height: 300,
      autoPlay: true,
      autoPlayInterval: const Duration(seconds: 3),
      enlargeCenterPage: true,
      viewportFraction: 0.32,
      enableInfiniteScroll: true,
    ),
    items: [

      
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: const DecorationImage(
            image: AssetImage("assets/shaheen8.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),

      
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: const DecorationImage(
            image: AssetImage("assets/shaheen9.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),

    
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: const DecorationImage(
            image: AssetImage("assets/shaheen10.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),

      
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: const DecorationImage(
            image: AssetImage("assets/shaheen11.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),

      
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: const DecorationImage(
            image: AssetImage("assets/shaheen12.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),

  
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: const DecorationImage(
            image: AssetImage("assets/shaheen13.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),

    ],
  ),
),
Padding(
   padding: const EdgeInsets.only(left:25),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      const Text(
        "Download Our Bookkaru Mobile App Now",
        style: TextStyle(
          color: Colors.yellow,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(height: 8),

      const Text(
        "Book hassle-free and travel",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),

      RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: "with ease - ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: "Download",
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      const Text(
        "Bookkaru Today!",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),

      const SizedBox(height: 20),

     Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [

  
    SizedBox(
      width: 180,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 15,
          ),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white24),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.apple,
                color: Colors.white,
                size: 35,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Download on the",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "App Store",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),

    const SizedBox(width: 10),

  
    SizedBox(
      width: 180, 
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 15,
          ),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white24),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.play_arrow,
                color: Colors.green,
                size: 35,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Get it on",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "Google Play",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  ],
)
    ],
  ),
),
const SizedBox(height: 30,),
Padding(
  padding: const EdgeInsets.all(20),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [

      Expanded(
        flex: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

          ],
        ),
      ),

      const SizedBox(width: 40),

      
      Expanded(
        flex: 1,
        child: Container(
          height: 550,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/mobile_app.png"),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    ],
  ),
)
      ],
      ),
    ),
  ],
),
),
    );
}
    }
    