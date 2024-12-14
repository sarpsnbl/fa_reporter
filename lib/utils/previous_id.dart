//this is created because the Google OCR works unexpectedly
//when the camera is reopened after it was closed

String previousID = "-1";

void setPreviousID(String id) {
  previousID = id;
}

/// Returns the previously stored ID as a string.
String getPreviousID() {
  return previousID;
}
