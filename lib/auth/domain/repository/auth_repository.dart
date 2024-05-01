
import 'package:blog_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository{

  Future<Either<Failure, String>> singUpWithEmailPassword({
    required String name,
    required String email,
    required String passwrod
  });

  Future<Either<Failure, String>> loginWithEmailPassword({
    required String email,
    required String passwrod
  });
  
}