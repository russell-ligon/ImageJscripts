




// Macro imports a series of ; or , delimited csv text images as a stack, makes avi video
// and saves composite data where each row = one frame from the stack
// Written by Russell Ligon, February 26, 2018
//


  run("Close All");
 
  
  Parentdir = getDirectory("Choose trial directory containing subfolders, each containing N semicolon delimited CSVs");
  print(Parentdir);
  outdir = getDirectory("Choose parent outputfolder");
  
  
  fileList=getFileList(Parentdir);
  folderList=newArray();
  
  //This loops through contents of Parentdir
// and keeps only folders (which end with /)
for(i=0; i<fileList.length; i++){ // list only sub-folder names
	//print(fileList[i]);
	//print(indexOf(fileList[i], "Standard"));
	//print(matches(fileList[i],".*tandard.*"));
	//print(endsWith(fileList[i], ".jpg")==1 & (indexOf(fileList[i], "Standard")<0));
	
	//Finds JPGs and jpgs w/o "tandard" in the name, adds them to tiffList
	/*
	if(endsWith(fileList[i], ".jpg")==1 && (matches(fileList[i],".*tandard.*")<1))
		tiffList = Array.concat(tiffList, fileList[i]);
	if(endsWith(fileList[i], ".JPG")==1 && (matches(fileList[i],".*tandard.*")<1))
		tiffList = Array.concat(tiffList, fileList[i]);
	if((matches(fileList[i],".*tandard.*")==1) && endsWith(fileList[i], ".JPG")==1)
		standardimage = fileList[i];	
	*/
	if(endsWith(fileList[i], "/")==1)
		folderList = Array.concat(folderList, fileList[i]);		
}



print("There are "+folderList.length+" folders to process");
  
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
 
 
 

	list = getFileList(folderDIR4);
	csvList=newArray();

	filenametemplate=list[0];
	
	parts2=split(filenametemplate, "_");


	startingstring=parts2[2];
	startingstring=replace(startingstring, ".csv", "");
	//startingstring=dir+"Record_2018----------------";
 	
	runas= "semicolon!";

	FrameNum = list.length;	
		
	TimeStamp = "true";
	
	startfile=startingstring;

	startfile=parts2[0]+"_"+parts2[1]+"_"+startfile+".csv";
	
	////////////////////////////////////

		fontS= 10;
		x1= 5;
		y1 = 470;	
		col = "white";
	
	/////////////////////////////////////////////////
	

csvList=list;	
/*	
	for(i=0; i<list.length; i++){ // list only csv files
		if(list[i]==startfile)
			activateflag=1;
		
		if(endsWith(list[i], ".csv")==1 && activateflag==1){
			csvList = Array.concat(csvList, list[i]);
			print(list[i]);
		}
		
		//this *breaks* the loop once the frameset is long enough
		if(csvList.length>FrameNum)
			i=list.length;
		
	}
*/	
	a2 = Array.trim(csvList, FrameNum);
	csvList=a2;

 
  start=0;
  stop=FrameNum;
  openimages=0;
  
  dir=folderDIR4;
setBatchMode(true);
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
						
						endloc=indexOf(file, ".csv");
						startloc=indexOf(file, "Record_2019");;
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
	  
	  if(start>csvList.length){
		  
	  } else {
		 
		if(openimages>1){ 
		run("Images to Stack", "use");
		wait(1000);
		}
		//make sure odd extra,empty line didn't creep in
		makeRectangle(0, 0, 640, 480);
		run("Crop");
	
	
	
	
	
		
		//call("ij.plugin.Macro_Runner.runPython", script, nameout); 
		
		namesarray=newArray();
        for (n=1; n<=FrameNum; n++) {
			if(n<=nSlices){
			  setSlice(n);
			  namesarray = Array.concat(namesarray,getInfo("slice.label"));
			  setResult("Name", n-1, namesarray[n-1]);
			  updateResults();	
			}
		}

		//setMinAndMax(65, 85);
		
		
		
	  }

		trialquadname=foldernombre;
	run("Image Sequence... ", "format=TIFF name="+trialquadname+" use save=["+outviddirOUT4+"/T008.test0000.tif]");

	wait(2000);
	
  run("Close All");
	
}
  