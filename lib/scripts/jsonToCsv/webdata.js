const fs = require('fs');


// Read the JSON file
function spaceJson(){
const inputFile = './bottomHalf.json';
const outputFile = './bottom_half_spaced.json';    
fs.readFile(inputFile, 'utf8', (err, data) => {
    if (err) {
        console.error('Error reading the input file:', err);
        return;
    }

    // Parse the JSON data
    const jsonData = JSON.parse(data);
    const columns = Object.keys(jsonData[0]).join(',');
    // Convert JSON object to string with indentation
    const formattedJson = JSON.stringify(jsonData, null, 4);
// Write the formatted JSON to the output file

    fs.appendFile(outputFile, formattedJson, 'utf8', (err) => {
        if (err) {
            console.error('Error appending to the output file:', err);
        }
});
});
}
readDescriptions();
function readCourses(){
const inputFile = './intercepted_requests_new.json';
const outputFile = './classData1.csv';    
fs.readFile(inputFile, 'utf8', (err, data) => {
    if (err) {
        console.error('Error reading the input file:', err);
        return;
    }

    // Parse the JSON data
    const allCourses = JSON.parse(data);
    let columns = "ccode,cnumber,cname,credit_hours,lecture_hours,lab_hours,description,prereqs,\n";
    // Convert JSON object to string with indentation
    let rows = "";
    for(course of allCourses){
       const csvRow = `${course.SWV_CLASS_SEARCH_SUBJECT},${course.SWV_CLASS_SEARCH_COURSE},${course.SWV_CLASS_SEARCH_TITLE},${course.HRS_COLUMN_FIELD},${null},${null},${null},${null},\n`;
       rows+= csvRow;
   }
   columns = columns + rows;
fs.appendFile(outputFile, columns, 'utf8', (err) => {
        if (err) {
            console.error('Error appending to the output file:', err);
        }
    });

});
}

function readPrereqs(){
    const inputFile = './prereqs_spaced.json';
    const outputFile = './PrereqData.csv';    
    fs.readFile(inputFile, 'utf8', (err, data) => {
        if (err) {
            console.error('Error reading the input file:', err);
            return;
        }
    
        // Parse the JSON data
        const allCourses = JSON.parse(data);
        let columns = "ccode,cnumber,prereqs,\n";
        // Convert JSON object to string with indentation
        let rows = "";
        for(course of allCourses){
           const csvRow = `${course.subject},${course.number},${course.preReqs},\n`;
           rows+= csvRow;
       }
       columns = columns + rows;
    fs.appendFile(outputFile, columns, 'utf8', (err) => {
            if (err) {
                console.error('Error appending to the output file:', err);
            }
        });
    
    });
    }

    function readDescriptions(){
        const inputFile = './bottom_half_spaced.json';
        const outputFile = './DescriptionData2.csv';    
        fs.readFile(inputFile, 'utf8', (err, data) => {
            if (err) {
                console.error('Error reading the input file:', err);
                return;
            }
        
            // Parse the JSON data
            const allCourses = JSON.parse(data);
            let columns = "ccode,cnumber,description,\n";
            // Convert JSON object to string with indentation
            let rows = "";
            for(course of allCourses){
               const csvRow = `${course.subject},${course.number},\"${course.description}\",\n`;
               rows+= csvRow;
           }
           columns = columns + rows;
        fs.appendFile(outputFile, columns, 'utf8', (err) => {
                if (err) {
                    console.error('Error appending to the output file:', err);
                }
            });
        
        });
        }