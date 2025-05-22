String getDateInString(String dateString) {
  if (dateString == "Today") {
    return "Today";
  } else if (dateString == "Yesterday") {
    return "Yesterday";
  } else if (dateString == "Last7Days") {
    return "Last 7 Days";
  } else if (dateString == "Last30Days") {
    return "Last 30 Days";
  } else if (dateString == "Last365Days") {
    return "Last 365 Days";
  } else {
    return dateString;
  }
}
