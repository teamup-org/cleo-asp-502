// ==UserScript==
// @name         Copy POST Request Data
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  Copy and reuse POST request data
// @match        *://*/*
// @run-at document-start
// @grant unsafeWindow
// ==/UserScript==




(function() {
    //Will intercept the initial POST to get the table data and download the JSON. Table data will not load when this scripts is running.
    'use strict';

    console.log("🚀 Tampermonkey script loaded!");

function downloadJSON(data) {
    const jsonString = data
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

    let csvData = "";
    // ✅ Intercept XMLHttpRequest (XHR)
    const originalOpen = XMLHttpRequest.prototype.open;
    const originalSend = XMLHttpRequest.prototype.send;

    XMLHttpRequest.prototype.open = function(method, url) {
        this._requestMethod = method;
        this._requestURL = url;
        return originalOpen.apply(this, arguments);
    };

    XMLHttpRequest.prototype.send = function(body) {
        if (this._requestMethod === "POST") {
            if(this._requestURL.includes("/api/course-sections")){
            console.log("🔥 Intercepted XHR POST Request:", this._requestURL, body);
            const timestamp = new Date().toISOString();
            let requestData = JSON.stringify(body);

            this.addEventListener("readystatechange", function() {
                if (this.readyState === 4 && this.status === 200) {
                    console.log("✅ Intercepted XHR POST Response:", this.responseText);

                    //let responseData = JSON.stringify(this.responseText);
                    downloadJSON(this.responseText);
                }
            });
        }
                        return originalSend.apply(this, arguments);
        }
    };
})();