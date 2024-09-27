import 'package:egrocer/helper/generalWidgets/googleMapSearchLocationWidgets/flutterGooglePlaces.dart';
import 'package:egrocer/helper/utils/generalImports.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';

class ConfirmLocation extends StatefulWidget {
  final GeoAddress? address;
  final String from;

  const ConfirmLocation({Key? key, this.address, required this.from})
      : super(key: key);

  @override
  State<ConfirmLocation> createState() => _ConfirmLocationState();
}

class _ConfirmLocationState extends State<ConfirmLocation> {
  late GoogleMapController controller;
  late CameraPosition kGooglePlex;
  late LatLng kMapCenter;
  double mapZoom = 14.4746;

  List<Marker> customMarkers = [];
  late String googleMapCurrentStyle;

  @override
  void initState() {
    super.initState();

    kMapCenter = LatLng(0.0, 0.0);
    Future.delayed(Duration.zero).then((value) async {
      googleMapCurrentStyle =
          Constant.session.getBoolData(SessionManager.isDarkTheme)
              ? await rootBundle.loadString('assets/mapTheme/nightMode.json')
              : await rootBundle.loadString('assets/mapTheme/dayMode.json');
      await checkPermission();
    });

    kGooglePlex = CameraPosition(
      target: kMapCenter,
      zoom: mapZoom,
    );

    if (widget.address != null) {
      kMapCenter = LatLng(double.parse(widget.address!.lattitud!),
          double.parse(widget.address!.longitude!));

      kGooglePlex = CameraPosition(
        target: kMapCenter,
        zoom: mapZoom,
      );
    } else {
      checkPermission();
    }

    setMarkerIcon();
  }

  checkPermission() async {
    await hasLocationPermissionGiven().then(
      (value) async {
        if (value is PermissionStatus) {
          if (value.isGranted) {
            await Geolocator.getCurrentPosition().then((value) async {
              updateMap(value.latitude, value.longitude);
            });
          } else if (value.isDenied) {
            await Permission.location.request();
          } else if (value.isPermanentlyDenied) {
            if (!Constant.session.getBoolData(
                SessionManager.keyPermissionLocationHidePromptPermanently)) {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Wrap(
                    children: [
                      PermissionHandlerBottomSheet(
                        titleJsonKey: "location_permission_title",
                        messageJsonKey: "location_permission_message",
                        sessionKeyForAskNeverShowAgain: SessionManager
                            .keyPermissionLocationHidePromptPermanently,
                      ),
                    ],
                  );
                },
              );
            }
          }
        }
      },
    );
  }

  updateMap(double latitude, double longitude) {
    kMapCenter = LatLng(latitude, longitude);
    kGooglePlex = CameraPosition(
      target: kMapCenter,
      zoom: mapZoom,
    );
    setMarkerIcon();
    controller.animateCamera(CameraUpdate.newCameraPosition(kGooglePlex));
  }

  setMarkerIcon() async {
    MarkerGenerator(
      const MapDeliveredMarker(),
      (bitmaps) {
        setState(
          () {
            bitmaps.asMap().forEach(
              (i, bmp) {
                customMarkers.add(
                  Marker(
                    markerId: MarkerId("$i"),
                    position: kMapCenter,
                    icon: BitmapDescriptor.bytes(
                      bmp,
                      height: 24,
                      width: 24,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    ).generate(context);

    Constant.cityAddressMap =
        await getCityNameAndAddress(kMapCenter, context);

    if (widget.from == "location") {
      Map<String, dynamic> params = {};
      // params[ApiAndParams.cityName] = Constant.cityAddressMap["city"];

      params[ApiAndParams.longitude] = kMapCenter.longitude.toString();
      params[ApiAndParams.latitude] = kMapCenter.latitude.toString();

      await context
          .read<CityByLatLongProvider>()
          .getCityByLatLongApiProvider(context: context, params: params);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBar(
          context: context,
          title: CustomTextLabel(
            jsonKey: "confirm_location",
          ),
        ),
        body: PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (didPop) {
              return;
            } else {
              Future.delayed(const Duration(milliseconds: 500))
                  .then((value) => Navigator.pop(context, true));
            }
          },
          child: Column(children: [
            Expanded(
              child: Stack(
                children: [
                  PositionedDirectional(
                    top: 0,
                    end: 0,
                    start: 0,
                    bottom: 0,
                    child: mapWidget(),
                  ),
                  PositionedDirectional(
                    top: 15,
                    end: 15,
                    start: 15,
                    child: Row(children: [
                      Expanded(
                          child: GestureDetector(
                        onTap: () async {
                          Prediction? p = await PlacesAutocomplete.show(
                              context: context,
                              apiKey: Constant.googleApiKey,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                  color: ColorsRes.mainTextColor,
                                ),
                              ),
                              textStyle: TextStyle(
                                color: ColorsRes.mainTextColor,
                              ));

                          displayPrediction(p, context).then(
                            (value) {
                              if (value != null) {
                                updateMap(
                                  double.parse(value.lattitud ?? "0.0"),
                                  double.parse(
                                    value.longitude ?? "0.0",
                                  ),
                                );
                              }
                            },
                          );
                        },
                        child: Container(
                          decoration: DesignConfig.boxDecoration(
                            Theme.of(context).scaffoldBackgroundColor,
                            10,
                          ),
                          child: ListTile(
                            title: TextField(
                              enabled: false,
                              decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                hintText: getTranslatedValue(
                                    context, "search_location_hint"),
                              ),
                            ),
                            contentPadding: EdgeInsetsDirectional.only(
                              start: Constant.size12,
                            ),
                            trailing: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.search,
                                color: ColorsRes.mainTextColor,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      )),
                      SizedBox(width: Constant.size10),
                      GestureDetector(
                        onTap: () async {
                          await checkPermission();
                        },
                        child: Container(
                          decoration: DesignConfig.boxGradient(10),
                          padding: EdgeInsets.symmetric(
                              horizontal: 18, vertical: 18),
                          child: defaultImg(
                            image: "my_location_icon",
                            iconColor: ColorsRes.mainIconColor,
                          ),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
            confirmBtnWidget(),
          ]),
        ));
  }

  Widget mapWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: kGooglePlex,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      onTap: (argument) async {
        updateMap(argument.latitude, argument.longitude);
      },
      onMapCreated: _onMapCreated,
      markers: customMarkers.toSet(),
      zoomControlsEnabled: true,
      zoomGesturesEnabled: true,
      style: googleMapCurrentStyle,
      onCameraMove: (position) {
        mapZoom = position.zoom;
      },
      // markers: markers,
    );
  }

  Future<void> _onMapCreated(GoogleMapController controllerParam) async {
    controller = controllerParam;
  }

  confirmBtnWidget() {
    return Card(
      color: Theme.of(context).cardColor,
      surfaceTintColor: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (widget.from == "location" &&
                  !context.read<CityByLatLongProvider>().isDeliverable)
              ? CustomTextLabel(
                  jsonKey: "does_not_delivery_long_message",
                  style: Theme.of(context).textTheme.bodySmall!.apply(
                        color: ColorsRes.appColorRed,
                      ),
                )
              : const SizedBox.shrink(),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 20, end: 20, top: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                defaultImg(
                  image: "address_icon",
                  iconColor: ColorsRes.appColor,
                  height: 25,
                  width: 25,
                ),
                getSizedBox(
                  width: 20,
                ),
                Expanded(
                  child: CustomTextLabel(
                    text: Constant.cityAddressMap["address"] ?? "",
                  ),
                ),
              ],
            ),
          ),
          if ((widget.from == "location" &&
                  context.read<CityByLatLongProvider>().isDeliverable) ||
              widget.from == "address")
            ConfirmButtonWidget(
              voidCallback: () {
                Constant.session.setData(SessionManager.keyLongitude,
                    kMapCenter.longitude.toString(), false);
                Constant.session.setData(SessionManager.keyLatitude,
                    kMapCenter.latitude.toString(), false);
                if (widget.from == "location" &&
                    context.read<CityByLatLongProvider>().isDeliverable) {
                  context
                      .read<CartListProvider>()
                      .getAllCartItems(context: context);
                  Constant.session.setData(SessionManager.keyAddress,
                      Constant.cityAddressMap["address"], true);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    mainHomeScreen,
                    (Route<dynamic> route) => false,
                  );
                } else if (widget.from == "address") {
                  Future.delayed(const Duration(milliseconds: 500)).then(
                    (value) {
                      Navigator.pop(context, true);
                    },
                  );
                }
              },
            )
        ],
      ),
    );
  }

  @override
  Future<void> didChangeDependencies() async {
    googleMapCurrentStyle =
        Constant.session.getBoolData(SessionManager.isDarkTheme)
            ? await rootBundle.loadString('assets/mapTheme/nightMode.json')
            : await rootBundle.loadString('assets/mapTheme/dayMode.json');
    setState(() {});
    super.didChangeDependencies();
  }
}
