// Clear the output panel 
fl.outputPanel.clear();

// Create a reference to the publishing profile we generate for each file
var profpath = fl.configURI + 'Publish%20Profiles/png.xml';

var folderURI = decodeURI(fl.browseForFolderURL("Select a folder.").split("file:///").join(""));
var folderItems = folderURI.split("/");
var saveDir = "/" + folderItems.slice(1,folderItems.length).join("/") + "/";


var doc = fl.getDocumentDOM();
var itemList = doc.library.items;

fl.trace("Running");

function createItemArrays(){
	var item;
	
	for (var i=0; i<itemList.length; i++) {
		item = itemList[i];
		if (item.itemType == "bitmap"){
			updatePNG(item);
		}
	}
}

function updatePNG(item) {
	
	
	//item.setItemProperty('sourceFilePath',newSourcePath);
		 
	log("************************************************");
	log("updatePNG: "+getShortName(item));
	log(item);
	log("************************************************");
	
	var newSourcePath = "file://"+ saveDir + getShortName(item);
	//item.linkageURL = newSourcePath;
	
	
	log("item.name"+item.name);
	log("item.sourceFilePath: "+item.sourceFilePath);
	log("item.linkageURL: "+item.linkageURL);
	log("newSourcePath: "+newSourcePath);
	log("item.sourceFileExists: "+item.sourceFileExists);
	log("item.compressionType: "+item.compressionType);
	log("saveDir: "+saveDir);
		
	//for (var prop in item){
	//	log("item["+prop+"] = "+item[prop]);
	//}
	
}

function getShortName(item){
	var itemNameArray;
	var itemName;
	
	itemNameArray = item.name.split("/");
	itemName = itemNameArray[itemNameArray.length - 1];
	
	//itemName = itemName.replace(".png","");
	
	return itemName;
}




function log(msg){
	fl.trace(msg);
}


createItemArrays();


