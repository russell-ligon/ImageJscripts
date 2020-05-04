




// Macro imports a series of ; or , delimited csv text images as a stack, makes avi video
// and saves composite data where each row = one frame from the stack
// Written by Russell Ligon, February 26, 2018
//


  run("Close All");
  
  Parentdir = getDirectory("Choose trial directory containing subfolders, each containing semicolon delimited CSVs");
  print(Parentdir);
  outdir = getDirectory("Choose parent outputfolder");
  
  fileList=getFileList(Parentdir);
  folderList=newArray();
  
  
//This loops through contents of Parentdir
// and keeps only folders (which end with /)
for(i=0; i<fileList.length; i++){ // list only sub-folder names
 	if(endsWith(fileList[i], "/")==1)
		folderList = Array.concat(folderList, fileList[i]);		
}

print("There are "+folderList.length+" folders to process");

TimeStamp = "true";

  if(TimeStamp=="true"){
	  /*
	  Dialog.create("TimeStamp Settings");
		Dialog.addNumber("FontSize", 10);
		Dialog.addNumber("x coordinates", 5);
		Dialog.addNumber("y coordinates",470);
		Dialog.addChoice("FontColor",newArray("white","yellow","green","pink"));
	  Dialog.show();
	*/
		//fontS= Dialog.getNumber();
		//x1= Dialog.getNumber();
		//y1 = Dialog.getNumber();	
		//col = Dialog.getChoice();
		fontS=10;
		x1= 5;
		y1 = 470;	
		col = "white";
  }
  

for(q=0; q<folderList.length; q++){ // cycle through every folder in folderList
  print("Processing folder "+(q+1)+" out of "+folderList.length);
  
		foldernombre=folderList[q];
		folderDIR2=Parentdir+foldernombre;
		folderDIR3= replace(folderDIR2, "\\", "/");
		folderDIR4= replace(folderDIR3, "/", "\\");
		print(folderDIR4);

				
	
		outviddirOUT=outdir+foldernombre;
		outviddirOUT3= replace(outviddirOUT, "\\", "/");
		outviddirOUT4= replace(outviddirOUT3, "/", "\\");
		
		File.makeDirectory(outviddirOUT4);

		dir=folderDIR4;	
 
		list = getFileList(dir);
		csvList=newArray();

	for(i=0; i<list.length; i++) // list only csv files
		if(endsWith(list[i], ".csv")==1)
			csvList = Array.concat(csvList, list[i]);
		

	
	runas="semicolon!";
	fileprefix ="201";
	FrameNum = 10000;
	

																								   
																											   

  hundogroups = round(csvList.length/FrameNum);

 
  start=0;
  stop=FrameNum;
  
  

		
		openimages=0;
	  for (i=start; i<stop; i++) {
		if(i<csvList.length){ 
		file = dir + csvList[i];
					
					if(runas=="comma!"){
					run("Text Image... ", "open=&file"); //use this for true comma separated csvs
					}
					if(runas=="semicolon!"){
					run("read semicolon", "open=&file");//read_semicolon is a custom java plugin written by R.A. Ligon, February 26, 2018
					}
					if(TimeStamp=="true"){		
						
						endloc=indexOf(file, ".");
						startloc=indexOf(file, fileprefix);
						
						timeinfo=substring(file, startloc,endloc);
						
						fontSize = fontS; 
						x = x1; 
						y = y1; 
						setColor(col); 
						setFont("SansSerif", fontSize); 
						
						//Overlay.remove; 
						Overlay.drawString(timeinfo, x, y); 
						Overlay.show; 
					}
			
		openimages=openimages+1;
		}
	  }
	  
		 
		if(openimages>1){ 
		run("Images to Stack", "use");
		wait(1000);
		}
		//make sure odd extra,empty line didn't creep in
		makeRectangle(0, 0, 640, 480);
		run("Crop");
	
	
		run("Image Sequence... ", "format=TIFF use save=["+outviddirOUT4+"/test0000.tif]");
		close();
	  }
  


  