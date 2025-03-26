import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  DateTime onlyDate() {
    return DateTime(year, month, day);
  }

  TimeOfDay onlyTime() {
    return TimeOfDay(hour: hour, minute: minute);
  }

  String dateToString(String pattern) {
    return DateFormat(pattern).format(this);
  }

  String formatChatDateToString() {
    final days = DateTime.now().difference(this).inDays;
    if (days == 0) {
      return "Today";
    }
    if (days == 1) {
      return "Yesterday";
    }

    if (days > 1 && days < 7) {
      return dateToString("EEEE");
    }
    return dateToString("dd-MMM-yyyy");
  }

  String convertToPostTime() {
    String time = "now";
    final DateTime now = DateTime.now();
    final diff = now.difference(this);
    final int seconds = diff.inSeconds;
    final int minutes = diff.inMinutes;
    final int hours = diff.inHours;
    final int days = diff.inDays;

    if (seconds > 0 && minutes == 0) time = "${seconds} sec ago";
    if (minutes > 0 && minutes < 60) time = "${minutes} min ago";
    if (hours > 0 && hours < 24) time = "$hours h ${minutes % 60} min ago";
    if (days == 1) time = "Yesterday at ${this.dateToString("hh:mm a")}";
    if (days > 1) time = this.dateToString("dd MMM yyyy hh:mm a");

    return time;
  }

  String convertToAgeDiff() {
    String time = "now";
    final DateTime now = DateTime.now();
    final diff = now.difference(this);
    final int seconds = diff.inSeconds;
    final int minutes = diff.inMinutes;
    final int hours = diff.inHours;
    final int days = diff.inDays;
    final int months = days ~/ 30;
    final int years = months ~/ 12;

    if (seconds > 0 && minutes == 0) time = "${seconds} sec";
    if (minutes > 0 && minutes < 60) time = "${minutes} min";
    if (hours > 0 && hours < 24) time = "$hours h ${minutes % 60} min";
    if (days > 0 && days < 31) time = "$days ${days > 1 ? "days" : "day"}";
    if (days > 30 && months > 0 && months < 13)
      time = "$months ${months > 1 ? "months" : "month"}";
    if (months > 12 && years > 0)
      time = "$years ${years > 1 ? "years" : "year"}";
    return time;
  }
}
