




// Macro imports a series of ; or , delimited csv text images as a stack, makes avi video
// and saves composite data where each row = one frame from the stack
// Written by Russell Ligon, February 26, 2018
//


  run("Close All");
  dir = getDirectory("Choose directory containing semicolon delimited CSVs");
  //outviddir = getDirectory("Choose temp vid directory");
 // summdir = getDirectory("Choose Summary CSV save location");
/*  summdir1= replace(summdir, "\\", "/");
  summdir2= replace(summdir1, "\\", "/");
  summdir3= replace(summdir2, "\\", "/");
  summdir4= replace(summdir3, "/", '\\');
  */
  
  
  
  list = getFileList(dir);
  csvList=newArray();

	for(i=0; i<list.length; i++) // list only csv files
		if(endsWith(list[i], ".csv")==1)
			csvList = Array.concat(csvList, list[i]);
		


  
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
		Dialog.addChoice("What is the file prefix?", newArray("Record_2018","Record_2018","2018","2019"));
		Dialog.addNumber("Number of frames per short avi?",10000);
		Dialog.addChoice("Add timestamp",newArray("true","false"));
		


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
	fileprefix= Dialog.getChoice();
	FrameNum = Dialog.getNumber();	
	TimeStamp = Dialog.getChoice();
	
	
	//scaleVal = Dialog.getNumber();
	//visualSystem = replace(visualSystem, "_", " ");
	//trials=Dialog.getNumber();
  
																								   
																											   
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
  
  hundogroups = round(csvList.length/FrameNum);

 
  start=0;
  stop=FrameNum;
  
  
  for(k=0;k<1;k++ ) {
		showProgress(k, hundogroups);
		showStatus("Processing stack "+k+" out of "+hundogroups);
		start=(k)*FrameNum;
		stop=(k+1)*FrameNum;
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
						startloc=indexOf(file, fileprefix);;
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
	
			nk=d2s(k, 0);	

			if(k<10){
			newk="0000"+nk;
			}
			if(k>9 && k<100){
			newk="000"+nk;
			}
			if(k>99 && k<1000){
			newk="00"+nk;
			}
			if(k>999 && k<10000){
			newk="0"+nk;
			}
	
	
	
	
	
		
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

		setMinAndMax(65, 85);
		
		
		
	  }
  }


  