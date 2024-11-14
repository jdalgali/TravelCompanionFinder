import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travelcompanionfinder/app_theme.dart';
import 'package:travelcompanionfinder/hotel_booking/hotel_app_theme.dart';

class TravelComplementScreen extends StatefulWidget{
  const TravelComplementScreen({super.key});

  @override
   State<TravelComplementScreen> createState() => _TravelScreen();
}

// this class is the page what opens when you click on a travel from anywhere(favorite, last travels, actual travel, explore page)
//TODO: siehe hotel_list_view for idea with Hotel Data Loadout
//Note: HotelAppTheme.buildLightTheme() ersetzt durch AppTheme
//Todo: Design überarbeiten + connecting to HotelListView in hotel_home_screen.dart
class _TravelScreen extends State<TravelComplementScreen> with TickerProviderStateMixin{
   final double infoHeight = 364.0;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;
  bool _isOverflowing = false;
  bool _isTapped = false;

  late final AnimationController animationController;
  late final Animation<double> animation;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: const Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<void> setData() async {
    animationController.forward();
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      setState(() {
        opacity1 = 1.0;
      });
    }
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      setState(() {
        opacity2 = 1.0;
      });
    }
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      setState(() {
        opacity3 = 1.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color temp = AppTheme.primaryColor;

    final double tempHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.width / 1.2) +
        24.0;
    return Material(
      //
      color: AppTheme.nearlyWhite,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.2,
                //TODO AWS S3 600x500 px
                //TODO Multi Image viewer for multiple images / image stack:
                //attention case-sensitive: everything in lowercase
                child: Image.asset('assets/hotel/complement_picture_complement_page.png'),
              ),
            ],
          ),
          Positioned(
            top: (MediaQuery.of(context).size.width / 1.2) - 24.0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.nearlyWhite,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32.0),
                    topRight: Radius.circular(32.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: AppTheme.grey.withOpacity(0.2),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: SingleChildScrollView(
                  child: Container(
                    constraints: BoxConstraints(
                        minHeight: infoHeight,
                        maxHeight:
                            tempHeight > infoHeight ? tempHeight : infoHeight),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Padding(
                          padding:
                              EdgeInsets.only(top: 32.0, left: 18, right: 16),
                          child: 
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              Text(
                                //TODO AWS GET DATA DB
                                'Chiang Mai\nJungle Expedition',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22,
                                  letterSpacing: 0.27,
                                  color: AppTheme.darkerText,
                                ),
                              ),
                              Text(
                                'Doi Inthanon National Park.',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w200,
                                  fontSize: 14,
                                  letterSpacing: 0.27,
                                  color: AppTheme.grey,
                                ),
                              ),
                            ]
                          ),
                        ),
                        //TODO: Insert Destination Region or City
                       
                         Padding(
                          padding: const EdgeInsets.only(
                            //padding of Text above and Price
                              left: 16, right: 16, bottom: 8, top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Row(
                                children: [
                                    Text(
                                    //TODO AWS GET DATA DB
                                    '\$8.50',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22,
                                      letterSpacing: 0.27,
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                    Text(
                                      '/night',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w200,
                                        fontSize: 14,
                                        letterSpacing: 0.27,
                                        color: AppTheme.primaryColor
                                      ),
                                    )
                                ]
                              ),
                              Row(
                                children: <Widget>[
                                  Column(
                                    children: [
                                      Card(
                                        color:AppTheme.nearlyWhite,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                        //this is for shadow:
                                        elevation: 1.0,
                                        child:
                                        SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                              //TODO: navigate to Uploader profile
                                              //onTap: () => Navigator.pop(context),
                                              child:  Center(
                                                //TODO AWS DB Load 120x120px
                                                  child:  Image.asset("assets/hotel/profile_example_transparent-01.png"),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        //TODO AWS GET Uploader Profile Name => DATA DB
                                        'Paul',
                                        //textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          letterSpacing: 0.27,
                                          color: AppTheme.grey,
                                        ),
                                      ),
                                            
                                      
                                    ]
                                    
                                  ),
                                  const SizedBox(width: 8,),
                                  const Text(
                                    //TODO AWS GET DATA DB
                                    '4.3',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22,
                                      letterSpacing: 0.27,
                                      color: AppTheme.grey,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.star,
                                    color: AppTheme.primaryColor,
                                    size: 24,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: opacity1,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: <Widget>[
                                //TODO AWS
                                getTimeBoxUI('24', 'Total people'),
                                getTimeBoxUI('3', 'Days'),
                                //beds or seats? if beds which bed size? => bed? queen size? king size?
                                getTimeBoxUI('2', 'Beds free'),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: opacity2,
                            child:  Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 8, bottom: 8),
                              child: LayoutBuilder(
                                // Beginning of LayoutBuilder
                                builder: (context, constraints) {
                                  // Define the text content here
                                  //TODO AWS DB
                                  const String textContent =
                                      "Welcome to our cozy retreat nestled in the heart of nature! This charming getaway offers breathtaking views, modern amenities, and a serene ambiance, perfect for unwinding. The open-plan living area has plenty of natural light, leading to a spacious deck where you can sip coffee while watching the sunrise. Located minutes from hiking trails and local attractions, our home combines tranquility with adventure. Enjoy a fully equipped kitchen, fast Wi-Fi, and a comfortable king-sized bed. Whether you’re here for a weekend escape or an extended stay, we’re here to make your experience unforgettable. Book your stay today!";

                                  // Create a TextPainter to measure text overflow
                                  const span = TextSpan(
                                    text: textContent,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w200,
                                      fontSize: 14,
                                      letterSpacing: 0.27,
                                      color: AppTheme.grey,
                                    ),
                                  );
                                  final tp = TextPainter(
                                    text: span,
                                    maxLines: 3,
                                    textDirection: TextDirection.ltr,
                                  )..layout(maxWidth: constraints.maxWidth);

                                  // Check if the text overflows and update state accordingly
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    setState(() {
                                      _isOverflowing = tp.didExceedMaxLines;
                                    });
                                  });

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const Text(
                                        textContent,
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 14,
                                          letterSpacing: 0.27,
                                          color: AppTheme.grey,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),

                                      if (_isOverflowing)
                                        const SizedBox(height: 5.5),

                                        GestureDetector(
                                          onTapDown: (_) {
                                            setState(() {
                                              _isTapped = true; // Set tapped state to true on tap down
                                            });
                                          },
                                          onTapUp: (_) {
                                            setState(() {
                                              _isTapped = false; // Reset tapped state on tap release
                                            });
                                            _showFullTextOverlay(context, textContent);
                                          },
                                          onTapCancel: () {
                                            setState(() {
                                              _isTapped = false; // Reset tapped state if tap is canceled
                                            });
                                          },
                                          child: Text(
                                            "Show More",
                                            style: TextStyle(
                                              color: AppTheme.grey.withOpacity(_isTapped ? 0.3 : 1.0), // Adjust opacity based on tap
                                              fontWeight: FontWeight.w600,
                                              decoration: TextDecoration.underline,
                                              decorationColor: AppTheme.grey.withOpacity(_isTapped ? 0.3 : 1.0),
                                              fontSize: 15.5,
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                }, // End of LayoutBuilder's builder
                              ),
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: opacity3,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16, bottom: 16, right: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // Container(
                                //   width: 62,
                                //   height: 48,
                                //   decoration: BoxDecoration(
                                //     color: AppTheme.nearlyWhite,
                                //     borderRadius: const BorderRadius.all(
                                //         Radius.circular(16.0)),
                                //     border: Border.all(
                                //         color: AppTheme.grey
                                //             .withOpacity(0.2)),
                                //   ),
                                //   child: TextButton(
                                //     style: TextButton.styleFrom(
                                //       shape: RoundedRectangleBorder(
                                //           borderRadius:
                                //               BorderRadius.circular(16.0)),
                                //     ),
                                //     onPressed: () {},
                                //     child: const Icon(
                                //       Icons.add,
                                //       color: AppTheme.primaryColor,
                                //       size: 28,
                                //     ),
                                //   ),
                                // ),
                                //const SizedBox(width: 16),
                                Expanded(
                                  child: Container(
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(32.0),
                                      ),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: AppTheme
                                                .primaryColor
                                                .withOpacity(0.5),
                                            offset: const Offset(1.1, 1.1),
                                            blurRadius: 10.0),
                                      ],
                                    ),
                                    child: Center(
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          minimumSize: const Size(1000, 48),
                                        ),
                                        onPressed: () {},
                                        child: const Text(
                                          'Join Travel',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                            letterSpacing: 0.0,
                                            color: AppTheme
                                                .nearlyWhite,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).padding.bottom,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.width / 1.2) - 24.0 - 35,
            right: 35,
            child: ScaleTransition(
              scale: CurvedAnimation(
                  parent: animationController, curve: Curves.fastOutSlowIn),
              child: Card(
                color: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0)),
                elevation: 10.0,
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: Center(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        minimumSize: const Size(60, 60),
                      ),
                      onPressed: () {},
                      child: const Icon(
                        Icons.favorite,
                        color: AppTheme.nearlyWhite,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left:5),
            child: Card(
              color:AppTheme.nearlyWhite,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              //this is for shadow:
              elevation: 2.0,
              child:
              SizedBox(
                width: AppBar().preferredSize.height,
                height: AppBar().preferredSize.height,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(AppBar().preferredSize.height),
                    onTap: () => Navigator.pop(context),
                    child: const Center(
                      child: Padding(
                         padding: EdgeInsets.only(left: 8.0),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: AppTheme.nearlyBlack,
                          size: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Function to show the full text overlay with a close button
  void _showFullTextOverlay(BuildContext context, String textContent) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppTheme.nearlyWhite,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios, 
                  color: AppTheme.nearlyBlack, 
                  size: 17, ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Text(
                  textContent,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontWeight: FontWeight.w200,
                    fontSize: 14,
                    letterSpacing: 0.27,
                    color: AppTheme.grey,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget getTimeBoxUI(String text1, String txt2) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.nearlyWhite,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: AppTheme.grey.withOpacity(0.2),
                offset: const Offset(1.1, 1.1),
                blurRadius: 8.0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 18.0, right: 18.0, top: 12.0, bottom: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                text1,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: AppTheme.primaryColor,
                ),
              ),
              Text(
                txt2,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: AppTheme.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}