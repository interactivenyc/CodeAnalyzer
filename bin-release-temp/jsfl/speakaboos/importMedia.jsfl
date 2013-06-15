var dom = fl.getDocumentDOM(); 
var lib = dom.library;
fl.outputPanel.clear()
var folderURI = fl.browseForFolderURL("Select a folder.");
fileList = new Array()
var importTypes = ["png", "bmp", "jpg", "mp3"];

// TODO: if files already exist, load the linkage list at start from the textField
// check each import against that linkage--- will need to do something similar to 
// the cache scheme in the app to replace newer files, not just accumulate old versions
// If there is a new item, add it, if replacement, delete the old item from the lib and list 
// and add the new one

function listFile(paths){
    var files=[]
    var folds=[]
    var files=FLfile.listFolder(paths,"files"); 

    for(i=0;i<files.length;i++)
    {   
        if(paths.lastIndexOf("/") != paths.length -1 )
        {
            paths+="/";         
        }
        fileList.push(paths + files[i]);
    }
    var folds = FLfile.listFolder(paths , "directories");

    for(var j=0;j<folds.length;j++)
    {           
        var subPath = paths + folds[j] + "/"        
        listFile(subPath);  

        //make sure that this stops at a reasonable point.
        if (fileList.length > 1000)
        return;
    }
}

function importFile(URI)
{
    var parts = URI.split("/");
    var documentName = parts.pop();
    var docFolder = parts.pop();
    parts = documentName.split(".");
    var type = parts[1];
    var linkageName = "";
    if (importTypes.indexOf(type) > -1) {
        if(dom.importFile(URI))
        {
            linkageName = parts[0].split("-").join("_") + "_" + type;
            linkageName = docFolder + "__" + linkageName;
            var fileItem;
            var i = lib.items.length;
            var found;
            do {
                i--;
                fileItem = lib.items[i];
                //fl.trace("do "+i+": "+fileItem.name+" - "+documentName);
                found = (fileItem.name == documentName);
            } while( (i > 0) && !found);
            if (found) {
                //fl.trace(fileItem.name);
                fileItem.linkageExportForAS=true;
                fileItem.linkageClassName = linkageName;
                if (type == "mp3") {
                    fileItem.linkageBaseClass = "flash.media.Sound";
                } else {
                    fileItem.linkageBaseClass = "flash.display.BitmapData";
                }
                fileItem.linkageExportInFirstFrame = true;
                //fl.trace(documentName);
                lib.newFolder(docFolder); 
                lib.moveToFolder(docFolder, documentName, true);
            } else {
                linkageName = "";
                fl.trace("error, item not found: "+documentName);
            }
        }
    }
    return linkageName;
}
fl.trace("starting import...");
listFile(folderURI);
var listing = [];
var linkage;
var n = fileList.length;
var classText =
    "package com.speakaboos.ipad.models.data {\n" +
    "// JSFL generated class, do not edit\n" +
    "    public class CacheLoaderResources {\n" +
    "        public static function getResourceMap():Object {\n" +
    "            return {";
for(i=0;i<n;i++) {
    //fl.trace("fileList["+i+"]="+ fileList[i]);
    linkage = importFile(fileList[i]);
    if (linkage) {
        classText += "\n                "+linkage+": "+linkage+",";
    }
}
classText = classText.slice(0, -1); // remove last comma
classText += "\n            }\n        }\n    }\n}\n";
//dom.addNewText({left:0, top:0, right:100, bottom:100});
//dom.setTextString(listing.join(","));
//dom.selectNone();
//dom.mouseClick({x:50, y:50}, false, true);
//dom.selection[0].name = "text";
//dom.convertToSymbol('movie clip', '', 'top left');
//lib.setItemProperty('linkageExportForAS', true);
//lib.setItemProperty('linkageExportForRS', false);
//lib.setItemProperty('linkageExportInFirstFrame', true);
//lib.setItemProperty('linkageClassName', 'LinkageList');
//lib.setItemProperty('scalingGrid',  false);
//TODO: get the location of the fla this is loading from? need to do something to avoid the hard-coded URL
var baseURI = fl.getDocumentDOM().pathURI;
baseURI = baseURI.slice(0, baseURI.indexOf("/fla")+1);
FLfile.write(baseURI + "src/com/speakaboos/ipad/models/data/CacheLoaderResources.as", classText);
// clean up stage
dom.selectAll();
dom.deleteSelection();
fl.trace("finished");

