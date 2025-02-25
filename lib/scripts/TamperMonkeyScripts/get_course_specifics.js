// ==UserScript==
// @name         Link Clicker
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  Copy and reuse POST request data
// @match        *://*/*
// @run-at document-start
// @grant unsafeWindow
// ==/UserScript==

(async function() {
    const requestsToGet = ["preReqs","program-restrictions",
                          "college-restrictions","level-restrictions",
                          "degree-restrictions","major-restrictions","minor-restrictions",
                          "minor-restrictions","concentrations-restrictions",
                          "field-of-study-restrictions","department-restrictions",
                          "cohort-restrictions","student-attribute-restrictions",
                          "classifications-restrictions","campus-restrictions"];
    function downloadJSON(data) {
    const jsonString = JSON.stringify(data);
    const blob = new Blob([jsonString], { type: "application/json" }); // Create a Blob from the JSON string
    const url = URL.createObjectURL(blob); // Create an object URL from the Blob

    const link = document.createElement("a");
    link.setAttribute("href", url);
    link.setAttribute("download", "intercepted_requests.json");
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    URL.revokeObjectURL(url); // Clean up the object URL
}
        let classesFound = 0;
        console.log("LINK CLICKER RUNNING");
        const courseArray = [];
        const prevLinks = [];
        const originalOpen = XMLHttpRequest.prototype.open;
        const originalSend = XMLHttpRequest.prototype.send;
        XMLHttpRequest.prototype.open = function(method, url) {
        this._requestMethod = method;
        this._requestURL = url;
        return originalOpen.apply(this, arguments);
    };
        XMLHttpRequest.prototype.send = function(body) {
        if (this._requestMethod === "POST" || "GET") {
            let foundRequest =requestsToGet.find(str => this._requestURL.includes(str));
            if(foundRequest){
            //console.log(foundRequest);
            //console.log("🔥 Intercepted XHR POST Request:", this._requestURL, body);
            const timestamp = new Date().toISOString();
            let requestData = JSON.stringify(body);

            this.addEventListener("readystatechange", function() {
                if (this.readyState === 4 && this.status === 200) {
                    const response = JSON.parse(this.responseText);
                    courseArray[courseArray.length-1][foundRequest] = response;
                    //console.log("✅ Intercepted XHR POST Response:", this.responseText);
                    //downloadJSON(this.responseText);
                }
            });
        }
            if(this._requestURL.includes("/api/course-section-details")){
             //console.log("🔥 Intercepted XHR POST Request: POOP", this._requestURL, body);
            const timestamp = new Date().toISOString();
            let requestData = JSON.stringify(body);
            this.addEventListener("readystatechange", function() {
                if (this.readyState === 4 && this.status === 200) {
                      const response = JSON.parse(this.responseText);
                      courseArray.push({subject: response.SUBJECT_CODE, number:response.COURSE_NUMBER, description:response.COURSE_DESCRIPTION});
                      //console.log(courseArray);
                    //downloadJSON(this.responseText);
                    classesFound++;
                    console.log(classesFound);
                }
            });
            }
        }
        return originalSend.apply(this, arguments);
    };
const wait = (time) => new Promise(resolve => setTimeout(resolve, time));
async function close(){
    let counter = 3;
    while(true){
        var buttons = document.getElementsByClassName("btn btn-default");
        buttons[3]?.click();
        if(buttons[3]){
            return;
        }
        if(!document.querySelector("modal-container") || counter == 0){
             return "not found";
        }
        counter--;
        await wait(100);
    }
}
    async function findAndClickLink() {
    await new Promise(async (resolve,reject) => {
    // Find all elements with a shadow root
    const elements = document.querySelectorAll('*');
    for(let element of elements){
        if (element.shadowRoot) {
            // First try to find the desktop-container inside the shadow root
            const container = element.shadowRoot.querySelector('.desktop-container');
            if (container) {
                const id = element?.parentElement?.parentElement.id;
                const link = container.querySelector('a[aria-label*="Open class details for"]');
                const text = link.ariaLabel;
                if (link && !prevLinks.some(otherText => text == otherText)) {
                    prevLinks.push(text);
                    //console.log('Found the link:', link);
                    link.click();
                    await close();
                    resolve();
                }
            }
        }
    }
    reject();
});
}
var errorCounter = 0;
var failed = false;
async function runTask() {
    try{
    await findAndClickLink();
    }
    catch{
       document.querySelector('.ag-body-viewport').scrollBy({ top: 600});
       await wait(500);
       errorCounter++;
        failed = true;
       if(errorCounter == 15){
       //downloadJSON(courseArray);
       }
    }
    if(!failed){
        errorCounter = 0;
    }
    failed = false;
    while(document.querySelector("modal-container")){
        const ans = await close();
        if(ans == "not found"){
           break;
        }
        await wait(100);
    }
    if(classesFound >= 2100){
        console.log("found all classes");
        await wait(3000);
        downloadJSON(courseArray);
    }
    else{
    console.log("Classes so Far",classesFound);
    setTimeout(runTask, 100);
    }
}
await wait(18000);
runTask();
})();