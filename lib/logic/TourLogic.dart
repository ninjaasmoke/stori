abstract class TourEvent {
  const TourEvent();
}

class NextTourEvent extends TourEvent {
  const NextTourEvent();
}

class PrevTourEvent extends TourEvent {
  const PrevTourEvent();
}

class CancelTourEvent extends TourEvent {
  const CancelTourEvent();
}

abstract class TourState {
  const TourState();
}

class TourState_Active extends TourState {
  const TourState_Active();
}
