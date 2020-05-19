import 'dart:io';
import 'dart:convert';

main() async {
  var apiUrl = Uri.parse('https://jsonplaceholder.typicode.com/todos/1');
  var client = HttpClient();
  
  HttpClientRequest request = await client.getUrl(apiUrl);
  
  //   var payload = {
//     'title':'Post 1',
//     'content': 'random text goes here',
//   };
  
//   request.write(json.encode(payload));
  
  HttpClientResponse response = await request.close();
  
  var resStream = response.transform(Utf8Decoder());
  await for(var data in resStream) {
    print('Received data: $data');
  }
  
  
  
}