importScripts("https://www.gstatic.com/firebasejs/8.4.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.4.1/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyDf6rgN-gGoCPLP6G_NHqVDAoLZ7UN2Yec",
  authDomain: "geovation-sandbox.firebaseapp.com",
  databaseURL: "...",
  projectId: "geovation-sandbox",
  storageBucket: "geovation-sandbox.appspot.com",
  messagingSenderId: "803321733289",
  appId: "1:803321733289:web:549cf7921cc3b9c98149b8",
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});
