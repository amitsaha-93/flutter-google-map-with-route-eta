import 'package:show_route_eta/model/Ro.dart';

class EstimationTimeResponse {
    List<String> destination_addresses;
    List<String> origin_addresses;
    List<Ro> rows;
    String status;

    EstimationTimeResponse({this.destination_addresses, this.origin_addresses, this.rows, this.status});

    factory EstimationTimeResponse.fromJson(Map<String, dynamic> json) {
        return EstimationTimeResponse(
            destination_addresses: json['destination_addresses'] != null ? new List<String>.from(json['destination_addresses']) : null, 
            origin_addresses: json['origin_addresses'] != null ? new List<String>.from(json['origin_addresses']) : null, 
            rows: json['rows'] != null ? (json['rows'] as List).map((i) => Ro.fromJson(i)).toList() : null,
            status: json['status'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['status'] = this.status;
        if (this.destination_addresses != null) {
            data['destination_addresses'] = this.destination_addresses;
        }
        if (this.origin_addresses != null) {
            data['origin_addresses'] = this.origin_addresses;
        }
        if (this.rows != null) {
            data['rows'] = this.rows.map((v) => v.toJson()).toList();
        }
        return data;
    }
}