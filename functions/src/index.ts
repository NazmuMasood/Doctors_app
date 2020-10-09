import * as functions from 'firebase-functions'
import * as admin from 'firebase-admin'

admin.initializeApp()

const db = admin.database()
const fcm = admin.messaging()

export const sendToPatientsOfASlot = functions.database.ref('/messages/{messageId}')
    .onCreate((snapshot, context) => {
        // Grab the current value of what was written to the Realtime Database.
        const original = snapshot.val()
        console.log('Doctor\'s Message: '+original.msg)
        //console.log('Message value', context.params.messageId, original)

        const payload : admin.messaging.MessagingPayload = {
            notification: {
                title: `Doctor ${original.dId}`,
                body: `${original.msg}`,
                icon: 'https://drive.google.com/file/d/1BUlK63xeTV6cP7SLPvWVhh7GfjreBOMy/view?usp=sharing',
                clickAction: 'FLUTTER_NOTIFICATION_CLICK'
            }
        }

        const patientIds : string[] = []

        // return db.ref('users').child('patients').orderByChild('email').equalTo('patient@gmail.com').once('value').then(snappy=>{
        //     const p1 = snappy.val()
        //     const key = Object.keys(p1)[0]
        //     const p1token = p1[key].fcmToken
        //     console.log('p1token '+p1token)
        // }).catch(err=>{console.log('err: '+err)})

        
        const appointmentsRef = db.ref('appointments').orderByChild('dHelper').equalTo(original.dHelper)
        return appointmentsRef.once('value').then(snap => {
            const promises = []

            const appointments = snap.val()
            const keys = Object.keys(appointments)
            for(const key of keys){
                const patientId = appointments[key].patientId 
                patientIds.push(patientId)
                console.log('Patient id: '+patientId)
                
                const promise = db.ref('users').child('patients').orderByChild('email').equalTo(patientId).once('value')
                promises.push(promise)
            }
            
            return Promise.all(promises)
       
        }).then(results => {     
            const fcmTokens : string[] = []
            results.forEach(result => {
                const patient = result.val()
                const pKey = Object.keys(patient)[0]
                const fcmToken = patient[pKey].fcmToken
                if(fcmToken != "" && fcmToken != null){
                    fcmTokens.push(fcmToken)
                    //console.log('fcmToken: '+fcmToken)
                }
            })

            console.log(`fcmTokens are - `+fcmTokens.toString())
            return fcm.sendToDevice(fcmTokens, payload)

        }).then((response) => {
            console.log('Successfully sent message:', response);
        }).catch(error => {
            console.log('error msg: '+error)
        })

        // This registration token comes from the client FCM SDKs.
        //const registrationToken = 'cvuRXgaASISaXi55IZ-35p:APA91bFsrZQF7h-3xKd48X7DooDbf7dNi5HysjOpkSTgl37yC0hFXlrs-MsaZofT6d5MCk-d0XTWXNk3BqDWI44PQo7wjgvZzfO-97XQrbp52I3VZgXo6vmjufV0ohC5iKkE80dgktIW';

        // fetchApptPatients(original.dHelper).
        //     catch(error => console.error("fetchApptPatients error: ", { error }));

        // var message = {
        //     data: {
        //     score: '850',
        //     time: '2:45'
        //     },
        //     token: registrationToken
        // };

        // // Send a message to the device corresponding to the provided registration token.
        // admin.messaging().send(message).then((response) => {
        //     // Response is a message ID string.
        //     console.log('Successfully sent message:', response);
        // })
        // .catch((error) => {
        //     console.log('Error sending message:', error);
        // });

        // fcm.sendToDevice(registrationToken, payload).then((response) => {
        //         console.log('Successfully sent message:', response);
        //     })
        //     .catch((error) => {
        //         console.log('Error sending message:', error);
        //     });

        
})


/*
async function fetchApptPatients(dHelper:string) : Promise<void>{
    const patientIds : string[] = [];

    const appointmentsRef = db.ref('appointments').orderByChild('dHelper').equalTo(dHelper);
    const snapshot = await appointmentsRef.once('value');
    if(snapshot.exists()){
        const appointments = snapshot.val();
        const keys = Object.keys(appointments);
        for(const key of keys){
            patientIds.push(appointments[key].patientId);
            console.log('Patient id: '+appointments[key].patientId);
        }
        
        console.log('Length of patientIds[] : '+patientIds.length);
        fetchUsers(patientIds).catch(error => console.error("root fetchUsers error: ", { error }));;
    }

}

async function fetchUsers(patientIds:string[]){
    const promises = [];
    const fcmTokens : string[] = [];

    for (const patientId of patientIds) {
        const usersRef = db.ref('users').child('patients').orderByChild('email').equalTo(patientId);

        // const userSnapshot = await usersRef.once('value');
        // if(userSnapshot.exists()){
        //     console.log('ekta paisii');
        //     const key = Object.keys(userSnapshot.val())[0];
        //     const fcmToken = userSnapshot.val()[key]['fcmToken'];
        //     console.log('fcmToken: '+fcmToken);
        //     fcmTokens.push(fcmToken);
        // } 


       const promise = usersRef.once('value');
        // .then(function(snap) {
        //     // The Promise was fulfilled.
        //     const key = Object.keys(snap.val())[0];
        //     console.log('snap val: '+snap.val()[key]['fcmToken']);
        //     const fcmToken = snap.val().fcmToken;
        //     console.log('fcmToken: '+fcmToken);
        //     fcmTokens.push(fcmToken);
        // }, function(error) {
        //     // The Promise was rejected.
        //     console.error('Fcm error: '+error);
        // });
        promises.push(promise);  

        // Promise.all(promises)
        // .then(function(results) {
        //     console.log('results : '+results.values.toString);
        //     results.forEach(function(userSnapshot) {
        //         if(userSnapshot.exists()){
        //                 console.log('hoalaaaa');
        //                 const users = userSnapshot.val();
        //                 const userKeys = Object.keys(users);
        //                 for(const key of userKeys){
        //                     fcmTokens.push(users[key].fcmToken);
        //                     console.log('FCM token of '+patientId+': '+users[key].fcmToken);
        //                 }
        //             } 
        //         // console.log('snapshotUser : '+snapshotUser.val.toString);
        //         // const fcmToken = snapshotUser.val().fcmToken;
        //         // console.log("FCM token: " + fcmToken);
        //         // fcmTokens.push(fcmToken);
        //     });
        //     console.log('FCMtokens[] length: '+fcmTokens.length);
        // })
        // .catch(error => console.error("fetchUsers error: ", { error }));

     
        
    }//for loop ends

    const dataSnapshots = await Promise.all(promises);
    // .then(function(dataSnapshots){
    //     console.log('results : '+dataSnapshots[0].val());
    //     for(const userSnapshot of dataSnapshots){
    //         console.log('ekta paisii : '+userSnapshot.val());
    //         const key = Object.keys(userSnapshot.val())[0];
    //         const fcmToken = userSnapshot.val()[key]['fcmToken'];
    //         console.log('fcmToken: '+fcmToken);
    //         fcmTokens.push(fcmToken);
    //     }    
    //     //results.forEach(function(userSnapshot) {
    //         //if(userSnapshot.exists()){
    //                 // console.log('hoalaaaa');
    //                 // const users = userSnapshot.val();
    //                 // const userKeys = Object.keys(users);
    //                 // for(const key of userKeys){
    //                 //     fcmTokens.push(users[key].fcmToken);
    //                 //     console.log('FCM token :'+users[key].fcmToken);
    //                 // }
    //         //} 
    //       //  // console.log('snapshotUser : '+snapshotUser.val.toString);
    //        // // const fcmToken = snapshotUser.val().fcmToken;
    //        // // console.log("FCM token: " + fcmToken);
    //         //// fcmTokens.push(fcmToken);
    //     //});
    //     console.log('FCMtokens[] length: '+fcmTokens.length);
    //     })
      //  .catch(error => console.error("fetchUsers error: ", { error }));

    let count = 0;
    while(fcmTokens.length<dataSnapshots.length && count<5){
        for(const userSnapshot of dataSnapshots){
            if(userSnapshot.exists()){
                console.log('ekta paisii : '+userSnapshot.val());
                const key = Object.keys(userSnapshot.val())[0];
                const fcmToken = userSnapshot.val()[key]['fcmToken'];
                console.log('fcmToken: '+fcmToken);
                fcmTokens.push(fcmToken);
            }
            count++;
        }
    } 
}
*/














// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
