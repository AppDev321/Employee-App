importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
/*  apiKey: "...",
  authDomain: "...",
  databaseURL: "...",
  projectId: "...",
  storageBucket: "...",
  messagingSenderId: "...",
  appId: "...",*/

    apiKey: "AIzaSyAWaOsY4NxIIKyKJjXpSS7rsYoyp7v7Uxs",
        projectId: "innovative-technology-f0514",

        messagingSenderId: "1094712997761",
        appId: "1:1094712997761:android:8b1c88f3fe70662da5da80"
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});