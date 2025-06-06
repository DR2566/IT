let axios = require("axios");
let fs = require("fs");

let subjects = {
    "ib002": {
        timestampExecution: 1744642800,
        URL_registration: "https://is.muni.cz/auth/seminare/student?fakulta=1433;obdobi=9604;studium=1320517;predmet=1643294;prihlasit=827301;akce=podrob;provest=1;stopwindow=1;design=m",
    },
}

const cookie_1 = "C2O0PGnziuePBbeFPgxeUrHj";  //  __Host-iscreds
const cookie_2 = "EUnrjabu8QzyghHcaJH2Q2JN";  //  __Host-issession

// -------------------------------------------------------------------------------------

const getAttributeKey = (URL_registration, attributeName) => {
    let attributeIndex = URL_registration.indexOf(attributeName) + attributeName.length + 1;
    let closestSemicolonIndex = attributeIndex + URL_registration.slice(attributeIndex).indexOf(";");

    let attributeValue = URL_registration.slice(attributeIndex, closestSemicolonIndex);

    return attributeValue;
}

const getHeader = (URL_registration) => {

    let predmet = getAttributeKey(URL_registration, "predmet");
    let obdobi = getAttributeKey(URL_registration, "obdobi");
    let studium = getAttributeKey(URL_registration, "studium");

    let header = {
        "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
        "accept-language": "cs-CZ,cs;q=0.9",
        "cache-control": "max-age=0",
        "priority": "u=0, i",
        "sec-ch-ua": "\"Google Chrome\";v=\"135\", \"Not-A.Brand\";v=\"8\", \"Chromium\";v=\"135\"",
        "sec-ch-ua-mobile": "?0",
        "sec-ch-ua-platform": "\"macOS\"",
        "sec-fetch-dest": "document",
        "sec-fetch-mode": "navigate",
        "sec-fetch-site": "same-origin",
        "sec-fetch-user": "?1",
        "upgrade-insecure-requests": "1",
        "cookie": `__Host-issession=${cookie_2}; __Host-iscreds=${cookie_1}`,
        "Referer": `https://is.muni.cz/auth/seminare/student?obdobi=${obdobi};studium=${studium};akce=podrob;predmet=${predmet}`,
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
        
        let header = getHeader(URL_registration);
        let currentTimestamp = Date.now();
        let delay = timestampExecution*1000 - currentTimestamp;
    
        if (delay < 0) {
            console.log(`The execution time has already passed for ${subjectName}`);
        } else {
            console.log(`Waiting for ${delay/1000}s before sending the request: ${subjectName}...`);
            setTimeout(() => {
                sendRequest(URL_registration, header, subjectName);
                console.log("sent");
            }, delay);
        }
    })
}

planReservations()
