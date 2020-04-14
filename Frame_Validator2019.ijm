




// Macro imports a series of ; or , delimited csv text images as a stack, makes avi video
// and saves composite data where each row = one frame from the stack
// Written by Russell Ligon, February 26, 2018
//


  run("Close All");
  dir = getDirectory("Choose directory containing semicolon delimited CSVs");
  
  
  //loop through info which will contain directories, and start times
  
  
  //outviddir = getDirectory("Choose temp vid directory");
 // summdir = getDirectory("Choose Summary CSV save location");
/*  summdir1= replace(summdir, "\\", "/");
  summdir2= replace(summdir1, "\\", "/");
  summdir3= replace(summdir2, "\\", "/");
  summdir4= replace(summdir3, "/", '\\');
  */
 
 	activateflag = 0;
	list = getFileList(dir);
	csvList=newArray();

	filenametemplate=list[0];
	
	parts2=split(filenametemplate, "_");

 
    startingstring="12-00-01";
	startingstring=parts2[2];
	startingstring=replace(startingstring, ".csv", "");
	//startingstring=dir+"Record_2018----------------";
  
	Dialog.create("CSV to AVI conversion settings");
	/*
		Dialog.addNumber("Future frames (how far into future to look for evap signature)?",240);
		Dialog.addNumber("If pixel is warmed in the future, how many frames back to jump back and check",10);
		Dialog.addNumber("Temperature above which is a mouse",79);
		Dialog.addNumber("Pee min temp",71);
		Dialog.addNumber("Pee evap temp threshold",67);
		Dialog.addNumber("Pixel distance for clustering",10);
		Dialog.addNumber("Minimum number of pixels to be considered a cluster",2);
	*/	
		Dialog.addChoice("What is the delimiter?", newArray("semicolon!","comma!"));
		Dialog.addToSameRow();
		
		
		Dialog.addNumber("Number of frames per short avi?",600);
		Dialog.addToSameRow();
		
		

		Dialog.addChoice("Add timestamp",newArray("true","false"));
		//Dialog.addToSameRow();
		
		Dialog.addString("Choose starting file for validation video",startingstring,90);

		Dialog.addString("Choose trial identifier","exampletrialname");
	Dialog.show();
/*
	FutureFrame = Dialog.getNumber();
	JumpSize = Dialog.getNumber();
	MouseT = Dialog.getNumber();
	WarmUp = Dialog.getNumber();
	CoolOff = Dialog.getNumber();
	Distance = Dialog.getNumber();
	minpix = Dialog.getNumber();
*/	
	runas= Dialog.getChoice();

	FrameNum = Dialog.getNumber();	
		
	TimeStamp = Dialog.getChoice();
	
	startfile=Dialog.getString();
	trialquadname=Dialog.getString();
	startfile=parts2[0]+"_"+parts2[1]+"_"+startfile+".csv";
	
	
	
	////////////////////////////////////
	/*
	  if(TimeStamp=="true"){
	  Dialog.create("TimeStamp Settings");
		Dialog.addNumber("FontSize", 10);
		Dialog.addNumber("x coordinates", 5);
		Dialog.addNumber("y coordinates",470);
		Dialog.addChoice("FontColor",newArray("white","yellow","green","pink"));
	  Dialog.show();
	
		fontS= Dialog.getNumber();
		x1= Dialog.getNumber();
		y1 = Dialog.getNumber();	
		col = Dialog.getChoice();
		
  }
	*/
		fontS= 10;
		x1= 5;
		y1 = 470;	
		col = "white";
	
	/////////////////////////////////////////////////
	

	
	
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
	
	a2 = Array.trim(csvList, FrameNum);
	csvList=a2;
	//scaleVal = Dialog.getNumber();
	//visualSystem = replace(visualSystem, "_", " ");
	//trials=Dialog.getNumber();
  
																								   
																											   

  
  hundogroups = round(csvList.length/FrameNum);

 
  start=0;
  stop=FrameNum;
  openimages=0;
  
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

	  
	   outdir = getDirectory("Choose outputfolder");
  
	  
run("Image Sequence... ", "format=TIFF name="+trialquadname+" use save=["+outdir+"/T008.test0000.tif]");

	wait(2000);
	
  run("Close All");

  