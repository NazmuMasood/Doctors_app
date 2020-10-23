import * as functions from 'firebase-functions'
import * as admin from 'firebase-admin'

admin.initializeApp()

const db = admin.database()
const fcm = admin.messaging()


export const sendDoneMessage = functions.database.ref('/appointments/{apptId}/flag')
    .onUpdate((change, context) => {
        // Exit when the data is deleted.
        if (!change.after.exists()) {
            return null;
        }
        // Grab the current value of what was written to the Realtime Database.
        const original = change.after.val()
        console.log('flag: '+original)
        if(original != 'done'){ return null; }
        //console.log('dHelper: '+original.dHelper)
        console.log('Flag value of key', context.params.apptId, original)
        
        const appointmentsRef = db.ref('appointments').child(context.params.apptId).child('pId')
        return appointmentsRef.once('value').then( pId => {
            console.log('pId: '+pId.val())

            const patientsRef = db.ref('users').child('patients').orderByChild('email').equalTo(pId.val())
            return patientsRef.once('value');             
        }).then( patientSnap => {
            const patient = patientSnap.val()
            const pKey = Object.keys(patient)[0]

            const promises = []
            const pr1 = db.ref('users').child('patients').child(pKey).child('rDue').set(context.params.apptId)
            promises.push(pr1)

            const fcmToken = patient[pKey].fcmToken
            console.log('fcmToken: '+fcmToken)
            if(fcmToken != "" && fcmToken != null){
                const payload : admin.messaging.MessagingPayload = {
                    notification: {
                        title: `Congratulations`,
                        body: `Your Doctor\'s App appointment successfully ended`,
                        icon: 'https://drive.google.com/file/d/1BUlK63xeTV6cP7SLPvWVhh7GfjreBOMy/view?usp=sharing',
                        clickAction: 'FLUTTER_NOTIFICATION_CLICK'
                    },
                    data: {
                        'apptKey' : context.params.apptId,
                        'showDialog': 'true',
                        'pKey': pKey
                    }
                }
    
                const pr2 = fcm.sendToDevice(fcmToken, payload)
                promises.push(pr2)

            }else{ return null; }

            return Promise.all(promises)
        }).then((response) => {
            console.log('rDue flag updated & successfully sent message:', response);
        }).catch(error => {
            console.log('error msg: '+error)
        })

})    


export const checkForSerialUpdt = functions.database.ref('/running-slots/{rsId}')
    .onWrite((change, context) => {
        // Exit when the data is deleted.
        if (!change.after.exists()) {
            return null;
        }
        // Grab the current value of what was written to the Realtime Database.
        const original = change.after.val()
        if(original.slotState == 'paused'){ 
            return null; 
        }
        console.log('CurrentSerial: '+original.currentSerial)
        console.log('dHelper: '+original.dHelper)
        //console.log('CurrentSerial value of key', context.params.rsId, original)    
        
        const dHelperFull = original.dHelper + '_pending'

        /*
         * Get the doctor's 'name' from the doctor's 'id'
         */
        let docName;
        const doctorsRef = db.ref('users').child('doctors').orderByChild('email').equalTo(original.dId)
        return doctorsRef.once('value').then( doctorSnap => {
            const doctor = doctorSnap.val()
            const dKey = Object.keys(doctor)[0]
            docName = doctor[dKey].name
            console.log('docName: '+docName)
            
            /*
             * Got the doctor's/sender's name, now get the unique 'appointments' list of the 'slot' that this message is targeted to  
             */
            const appointmentsRef = db.ref('appointments').orderByChild('dHelperFull').equalTo(dHelperFull)
                .limitToFirst(3) // if your serial is '5', start getting msg when serial is '3','4','5'
            return appointmentsRef.once('value')

        }).then(snap => {
            const promises = []

            const appointments = snap.val()
            const keys = Object.keys(appointments)
            for(const key of keys){
                const pId = appointments[key].pId 
                console.log('Patient id: '+pId)
                
                /*
                 * Got the 'appointments', have the 'pIds' from that, now get the 'fcmToken' of those 'pIds' 
                 */
                const promise = db.ref('users').child('patients').orderByChild('email').equalTo(pId).once('value')
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

            /*
             * Got the 'fcmTokens' of those 'patients', now create the notification/message payload
             */
            console.log(`fcmTokens are - `+fcmTokens.toString())
            const payload : admin.messaging.MessagingPayload = {
                notification: {
                    title: `Doctor ${docName}`,
                    body: `Current serial: ${original.currentSerial}`,
                    icon: 'https://drive.google.com/file/d/1BUlK63xeTV6cP7SLPvWVhh7GfjreBOMy/view?usp=sharing',
                    clickAction: 'FLUTTER_NOTIFICATION_CLICK'
                }
            }

            /*
             * Message is ready, now send to the targeted devices
             */
            return fcm.sendToDevice(fcmTokens, payload)

        }).then((response) => {
            console.log('Successfully sent message:', response);
        }).catch(error => {
            console.log('error msg: '+error)
        })


})



export const sendToPatientsOfASlot = functions.database.ref('/messages/{messageId}')
    .onCreate((snapshot, context) => {
        // Grab the current value of what was written to the Realtime Database.
        const original = snapshot.val()
        console.log('Doctor\'s Message: '+original.msg)
        //console.log('Message value', context.params.messageId, original)

        // return db.ref('users').child('patients').orderByChild('email').equalTo('patient@gmail.com').once('value').then(snappy=>{
        //     const p1 = snappy.val()
        //     const key = Object.keys(p1)[0]
        //     const p1token = p1[key].fcmToken
        //     console.log('p1token '+p1token)
        // }).catch(err=>{console.log('err: '+err)})

        /*
         * Get the doctor's 'name' from the doctor's 'id'
         */
        let docName;
        const doctorsRef = db.ref('users').child('doctors').orderByChild('email').equalTo(original.dId)
        return doctorsRef.once('value').then( doctorSnap => {
            const doctor = doctorSnap.val()
            const dKey = Object.keys(doctor)[0]
            docName = doctor[dKey].name
            console.log('docName: '+docName)
            
            /*
             * Got the doctor's/sender's name, now get the unique 'appointments' list of the 'slot' that this message is targeted to  
             */
            const appointmentsRef = db.ref('appointments').orderByChild('dHelperFull').equalTo(original.dHelperFull)
            return appointmentsRef.once('value')

        }).then(snap => {
            const promises = []

            const appointments = snap.val()
            const keys = Object.keys(appointments)
            for(const key of keys){
                const pId = appointments[key].pId 
                console.log('Patient id: '+pId)
                
                /*
                 * Got the 'appointments', have the 'pIds' from that, now get the 'fcmToken' of those 'pIds' 
                 */
                const promise = db.ref('users').child('patients').orderByChild('email').equalTo(pId).once('value')
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

            /*
             * Got the 'fcmTokens' of those 'patients', now create the notification/message payload
             */
            console.log(`fcmTokens are - `+fcmTokens.toString())
            const payload : admin.messaging.MessagingPayload = {
                notification: {
                    title: `Doctor ${docName}`,
                    body: `${original.msg}`,
                    icon: 'https://drive.google.com/file/d/1BUlK63xeTV6cP7SLPvWVhh7GfjreBOMy/view?usp=sharing',
                    clickAction: 'FLUTTER_NOTIFICATION_CLICK'
                }
            }

            /*
             * Message is ready, now send to the targeted devices
             */
            return fcm.sendToDevice(fcmTokens, payload)

        }).then((response) => {
            console.log('Successfully sent message:', response);
        }).catch(error => {
            console.log('error msg: '+error)
        })

        // This registration token comes from the client FCM SDKs.
        //const registrationToken = 'cvuRXgaASISaXi55IZ-35p:APA91bFsrZQF7h-3xKd48X7DooDbf7dNi5HysjOpkSTgl37yC0hFXlrs-MsaZofT6d5MCk-d0XTWXNk3BqDWI44PQo7wjgvZzfO-97XQrbp52I3VZgXo6vmjufV0ohC5iKkE80dgktIW';

        // fetchApptPatients(original.dHelperFull).
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
async function fetchApptPatients(dHelperFull:string) : Promise<void>{
    const pIds : string[] = [];

    const appointmentsRef = db.ref('appointments').orderByChild('dHelperFull').equalTo(dHelperFull);
    const snapshot = await appointmentsRef.once('value');
    if(snapshot.exists()){
        const appointments = snapshot.val();
        const keys = Object.keys(appointments);
        for(const key of keys){
            pIds.push(appointments[key].pId);
            console.log('Patient id: '+appointments[key].pId);
        }
        
        console.log('Length of pIds[] : '+pIds.length);
        fetchUsers(pIds).catch(error => console.error("root fetchUsers error: ", { error }));;
    }

}

async function fetchUsers(pIds:string[]){
    const promises = [];
    const fcmTokens : string[] = [];

    for (const pId of pIds) {
        const usersRef = db.ref('users').child('patients').orderByChild('email').equalTo(pId);

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
        //                     console.log('FCM token of '+pId+': '+users[key].fcmToken);
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
