const fs = require('fs');

const inputFile = './all courses spring 2025.json';
const outputFile = './aaaaaab.json';

// Read the JSON file
function spaceJson(){
fs.readFile(inputFile, 'utf8', (err, data) => {
    if (err) {
        console.error('Error reading the input file:', err);
        return;
    }

    // Parse the JSON data
    const jsonData = JSON.parse(data);
    jsonData.forEach((course) => {
        course.SWV_CLASS_SEARCH_JSON_CLOB = JSON.parse(course.SWV_CLASS_SEARCH_JSON_CLOB);
    });
    const columns = Object.keys(jsonData[0]).join(',');
    // Convert JSON object to string with indentation
    const formattedJson = JSON.stringify(jsonData, null, 6);
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
const inputFile = './all courses spring 2025.json';
const outputFile = './allCoursesNew2.csv';    
fs.readFile(inputFile, 'utf8', (err, data) => {
    if (err) {
        console.error('Error reading the input file:', err);
        return;
    }
    const coursesRead = [];
    // Parse the JSON data
    const allCourses = JSON.parse(data);
    let columns = "ccode,cnumber,cname,credit_hours,lecture_hours,lab_hours,description,prereqs,\n";
    // Convert JSON object to string with indentation
    let rows = "";
    for(course of allCourses){
    if(coursesRead.includes(course.SWV_CLASS_SEARCH_SUBJECT+course.SWV_CLASS_SEARCH_COURSE)){
        continue;
    }
       let s = course.SWV_CLASS_SEARCH_TITLE.replace("HNR-", '');
       const csvRow = `${course.SWV_CLASS_SEARCH_SUBJECT},${course.SWV_CLASS_SEARCH_COURSE},${s},${course.HRS_COLUMN_FIELD},${null},${null},${null},${null},\n`;
       coursesRead.push(course.SWV_CLASS_SEARCH_SUBJECT+course.SWV_CLASS_SEARCH_COURSE);
       rows+= csvRow;
   }
   columns = columns + rows;
fs.writeFile(outputFile, columns, 'utf8', (err) => {
        if (err) {
            console.error('Error appending to the output file:', err);
        }
    });

});
}
function readClasses(){
    const inputFile = './intercepted_requests (41).json';
    const outputFile = './allClasses.csv';    
    fs.readFile(inputFile, 'utf8', (err, data) => {
        if (err) {
            console.error('Error reading the input file:', err);
            return;
        }
        const coursesRead = [];
        // Parse the JSON data
        const allCourses = JSON.parse(data);
        let columns = "ccode,cnumber,crn,honors,\n";
        // Convert JSON object to string with indentation
        let rows = "";
        for(course of allCourses){
        let s= "";    
        if(course?.SWV_CLASS_SEARCH_ATTRIBUTES?.includes("Honors"))
            s = "T";
           const csvRow = `${course.SWV_CLASS_SEARCH_SUBJECT},${course.SWV_CLASS_SEARCH_COURSE},${course.SWV_CLASS_SEARCH_CRN},${s},\n`;
           rows+= csvRow;
       }
       columns = columns + rows;
    fs.writeFile(outputFile, columns, 'utf8', (err) => {
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
        let columns = "course_ccode,course_cnumber,prereq_ccode,prereq_cnumber,equi_id\n";
        const courses = {};
        // Convert JSON object to string with indentation
        let rows = "";
        for(course of allCourses){
           if(!Object.keys(courses).includes(course.subject+course.number)){
                courses[course.subject+course.number] = 1;
           }
           else{
                continue;
           }
           const words = course.preReqs?.split(' ');
           if(!words)
              continue;
           for(let i = 0; i < words.length-1; i++){
               if(words[i] == 'and'){
                courses[course.subject+course.number]++;
               } 
               let s = words[i] +' '+ words[i+1];
               if(s.match(/\b[A-Z]{3,}\b\s+\b\d+\b/g)){
                const csvRow = `${course.subject},${course.number},${words[i]},${words[i+1]},${courses[course.subject+course.number]},\n`;
                rows+= csvRow;    
               }
           }
       }
       columns = columns + rows;
    fs.writeFile(outputFile, columns, 'utf8', (err) => {
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
                let x = '';
                if(course.description)
                    x = course.description.replace(/["']/g, '');
               if(course.subject.length < 4)
                console.log(course.subject);
               const csvRow = `${course.subject},${course.number},\"${x}\",\n`;
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
        async function readClassMeetings(){
            const inputFile = './intercepted_requests (41).json';
            const outputFile = './allClassMeetings.csv';    
            fs.readFile(inputFile, 'utf8', (err, data) => {
                if (err) {
                    console.error('Error reading the input file:', err);
                    return;
                }
                const coursesRead = [];
                // Parse the JSON data
                const allClasses = JSON.parse(data);
                let rows = "";
                let columns = "crn,sunday,monday,tuesday,wednesday,thursday,friday,saturdaym,start_time,end_time,start_date,end_date,location,meeting_type\n";
                fs.writeFile(outputFile, columns, 'utf8', (err) => {
                    if (err) {
                        console.error('Error appending to the output file:', err);
                    }
                });
                // Convert JSON object to string with indentation
                for(course of allClasses){
                for(meeting of JSON.parse(course.SWV_CLASS_SEARCH_JSON_CLOB)){
                    let csvRow = `${course.SWV_CLASS_SEARCH_CRN},`;
                    csvRow = csvRow + `${meeting.SSRMEET_SUN_DAY},`;
                    csvRow = csvRow + `${meeting.SSRMEET_MON_DAY},`;
                    csvRow = csvRow + `${meeting.SSRMEET_TUE_DAY},`;
                    csvRow = csvRow + `${meeting.SSRMEET_WED_DAY},`;
                    csvRow = csvRow + `${meeting.SSRMEET_THU_DAY},`;
                    csvRow = csvRow + `${meeting.SSRMEET_FRI_DAY},`;
                    csvRow = csvRow + `${meeting.SSRMEET_SAT_DAY},`;
                    csvRow = csvRow + `${meeting.SSRMEET_BEGIN_TIME},`;
                    csvRow = csvRow + `${meeting.SSRMEET_END_TIME},`;
                    csvRow = csvRow + `${meeting.SSRMEET_START_DATE},`;
                    csvRow = csvRow + `${meeting.SSRMEET_END_DATE},`;
                    if(meeting.SSRMEET_ROOM_CODE != "ONLINE" && meeting.SSRMEET_ROOM_CODE)
                    csvRow = csvRow + `${meeting.SSRMEET_BLDG_CODE +" "+ meeting.SSRMEET_ROOM_CODE},`;
                    else
                    csvRow = csvRow + `${meeting.SSRMEET_ROOM_CODE},`;
                    csvRow = csvRow + `${meeting.SSRMEET_MTYP_CODE},\n`;
                    rows+= csvRow;
                }
               }
               fs.appendFile(outputFile, rows, 'utf8', (err) => {
                if (err) {
                    console.error('Error appending to the output file:', err);
                }
            });
            });
            }