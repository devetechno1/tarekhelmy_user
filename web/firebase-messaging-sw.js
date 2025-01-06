importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyAqoDzXTwqLpGxNOJGj5D1mL1e-2aYb_Mc",
    authDomain: "multi-master-1.firebaseapp.com",
    projectId: "multi-master-1",
    storageBucket: "multi-master-1.firebasestorage.app",
    messagingSenderId: "496804581818",
    appId: "1:496804581818:web:a67caf5bd69f2272884d83",
    measurementId: "G-FJL4MK8MZH"
});

const messaging = firebase.messaging();

messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            const title = payload.notification.title;
            const options = {
                body: payload.notification.score
              };
            return registration.showNotification(title, options);
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});