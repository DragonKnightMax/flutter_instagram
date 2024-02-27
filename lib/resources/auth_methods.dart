import 'dart:ffi';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/models/user.dart' as model;
import 'package:flutter_instagram/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap = await _firestore
      .collection('users')
      .doc(currentUser.uid)
      .get();
    return model.User.fromSnap(snap);
  }

  // sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = 'something went wrong';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {
        // register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        debugPrint(cred.user!.uid);

        String photoUrl = await StorageMethods()
          .uploadImageToStorage('profilePics', file, false);

        // add user to database
        model.User user = model.User(
          email: email,
          photoUrl: photoUrl,
          uid: cred.user!.uid,
          username: username,
          bio: bio,
          followers: [],
          following: []
        );
        await _firestore.collection('users').doc(cred.user!.uid)
          .set(user.toJson());

        res = "success";
      }
    // } on FirebaseAuthException catch (err) {
    //   if (err.code == 'invalid-email') {
    //     res = 'The email is badly formatted.';
    //   } else if (err.code == 'weak-password') {
    //     res = 'The password is too weak.';
    //   }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // sign in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'something went wrong';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = 'success';
      } else {
        res = 'Please enter all the fields';
      }
    }
    on FirebaseAuthException catch (err) {
      if (err.code == 'user-not-found') {
        res = 'No user found for that email.';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

}