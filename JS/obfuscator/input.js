let axios = require("axios");
let fs = require("fs");

let subjects = {
    "pb152": {
        timestampExecution: 1740585600,
        URL_registration: "https://is.muni.cz/auth/student/prihl_na_zkousky?fakulta=1433;obdobi=9604;studium=1320517;predmet=1643373;zkt=1243938;prihlasit=1;stopwindow=1",
        serie: "193288"
    },
    // "ib002": {
    //     timestampExecution: 1740585600,
    //     URL_registration: "https://is.muni.cz/auth/student/prihl_na_zkousky?fakulta=1433;obdobi=9604;studium=1320517;predmet=1643294;zkt=1243625;prihlasit=1;stopwindow=1",
    //     serie: "193241"
    // },
    // "pv004": {
    //     timestampExecution: 1740580620,
    //     URL_registration: "https://is.muni.cz/auth/student/prihl_na_zkousky?fakulta=1433;obdobi=9604;studium=1320517;predmet=1643386;zkt=1243638;prihlasit=1;stopwindow=1",
    //     serie: "193242"
    // },
}

const cookie_1 = "LSc5n4iYBAI7OoZGJ_A0jAMx";  //  __Host-iscreds
const cookie_2 = "NL8Lk7q5fsH1ejctbN_WyqT3";  //  __Host-issession

// -------------------------------------------------------------------------------------

const getHeader = (URL_registration, serie) => {
    let predmetIndex = URL_registration.indexOf("predmet");
    let predmet = URL_registration.slice(predmetIndex, predmetIndex + 7);

    let obdobiIndex = URL_registration.indexOf("obdobi");
    let obdobi = URL_registration.slice(obdobiIndex, obdobiIndex + 6);

    let header = {
        "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
        "accept-language": "cs-CZ,cs;q=0.9",
        "cache-control": "max-age=0",
        "priority": "u=0, i",
        "sec-ch-ua": "\"Not(A:Brand\";v=\"99\", \"Google Chrome\";v=\"133\", \"Chromium\";v=\"133\"",
        "sec-ch-ua-mobile": "?0",
        "sec-ch-ua-platform": "\"macOS\"",
        "sec-fetch-dest": "document",
        "sec-fetch-mode": "navigate",
        "sec-fetch-site": "same-origin",
        "sec-fetch-user": "?1",
        "upgrade-insecure-requests": "1",
        "cookie": `__Host-issession=${cookie_2}; __Host-iscreds=${cookie_1}`,
        "Referer": `https://is.muni.cz/auth/student/prihl_na_zkousky?obdobi=${obdobi};predmet=${predmet};serie=${serie}`,
        "Referrer-Policy": "strict-origin-when-cross-origin"
    }
    return header

}

let sendRequest = async (URL_registration, header, subjectName) => {
    let response = await axios.get(URL_registration, {
        headers: header
    })

    fs.writeFile(`${subjectName}_response.html`, response.data, (err) => { });
}

const planReservations = () => {
    Object.keys(subjects).forEach((subjectName)=>{
        // execution
        let URL_registration = subjects[subjectName].URL_registration;
        let timestampExecution = subjects[subjectName].timestampExecution;
        let serie = subjects[subjectName].serie;
        
        let header = getHeader(URL_registration, serie);
        let currentTimestamp = Date.now();
        let delay = timestampExecution*1000 - currentTimestamp;
    
        if (delay < 0) {
            console.log(`The execution time has already passed for ${subjectName}`);
        } else {
            console.log(`Waiting for ${delay/1000}s before sending the request: ${subjectName}...`);
            setTimeout(() => {
                sendRequest(URL_registration, header, subjectName);
                console.log("sent")
            }, delay);
        }
    })
}

planReservations()