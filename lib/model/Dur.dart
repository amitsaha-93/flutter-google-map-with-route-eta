class Dur {
    String text;
    int value;

    Dur({this.text, this.value});

    factory Dur.fromJson(Map<String, dynamic> json) {
        return Dur(
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