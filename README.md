# Flutter Firebase Project

This project is a Flutter application integrating Firebase services such as authentication and Firestore, along with local storage using shared preferences.

## Table of Contents
1. [Overview](#overview)
2. [Firebase Packages](#firebase-packages)
    - [firebase_auth](#firebase_auth)
    - [cloud_firestore](#cloud_firestore)
  

## Overview

This Flutter project utilizes Firebase for managing authentication, database, and app initialization, alongside shared preferences for storing local data persistently. It demonstrates how these packages work together to build a scalable mobile application.

## Firebase Packages

### firebase_auth: ^5.3.1
**firebase_auth** is used to handle user authentication. It supports sign-in methods like email/password, phone authentication, and third-party providers (Google, Facebook, etc.). This package enables secure user registration, login, and management.But here i used email/password method for login.

**Shared_preferences** is used for store user session that check if user is already logged in then it redirect user to homepage otherwise loginpage.

**Cloud Firestore** is used to store quiz questions and users score according to time stamp...


