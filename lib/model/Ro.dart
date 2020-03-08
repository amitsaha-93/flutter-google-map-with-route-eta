import 'package:show_route_eta/model/Element.dart';

class Ro {
    List<Element> elements;

    Ro({this.elements});

    factory Ro.fromJson(Map<String, dynamic> json) {
        return Ro(
            elements: json['elements'] != null ? (json['elements'] as List).map((i) => Element.fromJson(i)).toList() : null, 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        if (this.elements != null) {
            data['elements'] = this.elements.map((v) => v.toJson()).toList();
        }
        return data;
    }
}