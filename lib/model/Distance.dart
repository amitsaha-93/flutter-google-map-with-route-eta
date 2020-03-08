class Distance {
    String text;
    int value;

    Distance({this.text, this.value});

    factory Distance.fromJson(Map<String, dynamic> json) {
        return Distance(
            text: json['text'], 
            value: json['value'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['text'] = this.text;
        data['value'] = this.value;
        return data;
    }
}