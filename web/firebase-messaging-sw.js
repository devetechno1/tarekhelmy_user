importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyAa9o1pukwPb03NZ3QoUsJTcrIPHPphy0k",
    authDomain: "tarek-helmy.firebaseapp.com",
    projectId: "tarek-helmy",
    storageBucket: "tarek-helmy.firebasestorage.app",
    messagingSenderId: "1004955196439",
    appId: "1:1004955196439:web:62fecf5aac8815cd691052",
    measurementId: "G-KG0KKWJBHC"
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