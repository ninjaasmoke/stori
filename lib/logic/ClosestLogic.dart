import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:stori/models/UserModel.dart';
import 'package:stori/services/store.dart';

abstract class ClosestPeopleEvent {
  const ClosestPeopleEvent();
}

class FetchClosestPeopleEvent extends ClosestPeopleEvent {
  const FetchClosestPeopleEvent();
}

abstract class ClosestPeopleState {
  const ClosestPeopleState();
}

class InitClosestPeopleState extends ClosestPeopleState {
  const InitClosestPeopleState();
}

class FetchingClosestPeopleState extends ClosestPeopleState {
  final String loadMessage;
  const FetchingClosestPeopleState({required this.loadMessage});
}

class FetchedClosestPeopleState extends ClosestPeopleState {
  final List<AppUser> people;
  final GeoPoint currentLocation;
  const FetchedClosestPeopleState(
      {required this.people, required this.currentLocation});
}

class ErrorClosestPeopleState extends ClosestPeopleState {
  final String errorMessage;
  const ErrorClosestPeopleState({required this.errorMessage});
}

class ClosestPeopleBloc extends Bloc<ClosestPeopleEvent, ClosestPeopleState> {
  ClosestPeopleBloc() : super(InitClosestPeopleState());

  List<AppUser> people = [];
  Location location = new Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  @override
  Stream<ClosestPeopleState> mapEventToState(ClosestPeopleEvent event) async* {
    if (event is FetchClosestPeopleEvent) {
      yield FetchingClosestPeopleState(loadMessage: "Fetching people...");
      try {
        _permissionGranted = await location.hasPermission();
        _serviceEnabled = await location.requestService();
        if (_permissionGranted == PermissionStatus.denied) {
          _permissionGranted = await location.requestPermission();
        } else if (_permissionGranted == PermissionStatus.deniedForever) {
          throw Exception(
            "Location permission not granted! Please grant permission from device settings.",
          );
        }
        if (_serviceEnabled == true) {
          _locationData = await location.getLocation();
          GeoPoint currLoc = GeoPoint(
              _locationData.latitude ?? 0.0, _locationData.longitude ?? 0.0);
          yield FetchingClosestPeopleState(
              loadMessage: 'Fetching closest people...');
          try {
            FireStoreService service = new FireStoreService();
            people = await service.getClosestUsers(currLoc);
            print("Fetching people");
            yield FetchedClosestPeopleState(
                people: people, currentLocation: currLoc);
          } catch (e) {
            throw Exception(e);
          }
        } else {
          yield ErrorClosestPeopleState(
              errorMessage: "Location service not enabled.");
        }
      } catch (e) {
        yield ErrorClosestPeopleState(
          errorMessage: e.toString().contains("permission")
              ? e.toString()
              : "Unable to fetch closest people! ${e.toString()}",
        );
      }
    }
  }
}
