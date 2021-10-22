import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// const primaryColor = Color(0xffe8bd34);
const primaryColor = Color(0xfff8cf34);

const secondaryColor = Color(0xffac7028);
const darkColor = Color(0xff3d3d3d);
const redColor = Color(0xffe74c3c);
const greenColor = Color(0xff2ecc71);

const bool isLive = false;

BaseOptions dioOptions = BaseOptions(
  baseUrl:
      'http://194.163.158.234:8080/petrolnaas${isLive ? "-live" : ""}/public/api',
  connectTimeout: 5000,
  receiveTimeout: 3000,
);
