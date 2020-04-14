// clean results
//run("Clear Results");
// get all points
getSelectionCoordinates(xCoordinates, yCoordinates);
 
// chose name pattern for exporting
Savedir = getDirectory("Choose output folder");


Dialog.create("Polygon values settings");
Dialog.addString("Name of polygon (e.g. T001.A13.L.a1)","");
Dialog.show();

fileName= Dialog.getString();
fileName2=Savedir+fileName; 

// export as CSV file
for(i=0; i<lengthOf(xCoordinates); i++) {
    setResult("X", i, xCoordinates[i]);
    setResult("Y", i, yCoordinates[i]);
}
updateResults();
savestringfull=fileName2+".csv";
saveAs("Results", savestringfull);

   if (isOpen("Results")) {
       selectWindow("Results");
       run("Close");
   }