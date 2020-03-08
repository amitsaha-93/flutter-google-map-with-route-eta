import 'package:show_route_eta/model/Distance.dart';
import 'package:show_route_eta/model/Dur.dart';

class Element {
    Distance distance;
    Dur duration;
    String status;

    Element({this.distance, this.duration, this.status});

    factory Element.fromJson(Map<String, dynamic> json) {
        return Element(
            distance: json['distance'] != null ? Distance.fromJson(json['distance']) : null, 
            duration: json['duration'] != null ? Dur.fromJson(json['duration']) : null,
            status: json['status'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['status'] = this.status;
        if (this.distance != null) {
            data['distance'] = this.distance.toJson();
        }
        if (this.duration != null) {
            data['duration'] = this.duration.toJson();
        }
        return data;
    }
}