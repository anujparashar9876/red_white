class AppException implements Exception{
  final _message;
  final _prefix;
  AppException([this._message,this._prefix]);
  String toString(){
    return '$_prefix$_message';
  }
}
class FetchDataException extends AppException{
  FetchDataException(String? message):super('Error while fetching data: $message','ERROR');

}
class BadRequestException extends AppException{
  BadRequestException(String? message): super("$message Bad Request","BAD REQUEST"); 
}
class UnauthorisedException extends AppException{
  UnauthorisedException(String? message):super("You are not authorised to access this resource! : $message","UNAUTHORIZED ACCESS!");
} 
class InvalidInputException extends AppException{
  InvalidInputException(String? message):super("Invalid Input : $message");
}
class Uint8ListConvertException extends AppException {
  Uint8ListConvertException(String? message):super("Invalid : $message");
}

class AWSBucketException extends AppException {
  AWSBucketException(String? message):super("Invalid : $message");
}