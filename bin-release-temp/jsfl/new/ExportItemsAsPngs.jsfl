// Create a reference to the publishing profile we generate for each file
var profpath = fl.configURI + 'Publish%20Profiles/png.xml';

// Clear the output panel 
fl.outputPanel.clear()

// Get a location to export images to. trim the file:/// from it using join and split
var folderURI = decodeURI(fl.browseForFolderURL("Select a folder.").split("file:///").join(""));

// split path into an array on the forward slash
var folderItems = folderURI.split("/");

// On the Mac we need to remove the first item in the path
var saveDir = "/" + folderItems.slice(1,folderItems.length).join("/") + "/";

// if there is a save Directory specified then process the library items
if (saveDir) {
    // Get the Document object of the currently active document (FLA file)
    var doc = fl.getDocumentDOM();

    // Loop through all the items in the library
    for (idx in doc.library.items) {
    
        // get a reference to the current item
        var currentItem = doc.library.items[idx];
        fl.trace('currentItem.name: '+currentItem.name);
        fl.trace('currentItem.itemType: '+currentItem.itemType);

        // Check of the linkageIdentifier property of the current item is
        // set, if not ignore the item.
        if(currentItem.linkageIdentifier != undefined) {
            
            fl.trace("currentItem.linkageIdentifier: "+currentItem.linkageIdentifier);
            
            // export the current item as a png
            exportItemAsPng(currentItem)
        }
    }
}

function exportItemAsPng(item) {
    fl.trace('exportItemAsPng');
    fl.trace(item.linkageIdentifier);
    
    // build a filename using the linkageIdentifier 
    var pngName = saveDir + item.linkageIdentifier +".png";
        
    // selects the specified library item (true = replace current selection)
    doc.library.selectItem(item.name, true);
    
    // gets an array of all currently selected items in the library.
    var selectedItems = doc.library.getSelectedItems();
    
    fl.trace("selectedItems: "+selectedItems[0].type);
    
    // Add the current library item to the stage
    doc.library.addItemToDocument({x:0, y:0});

    // array of selected items in the document
    var w = doc.selection[0].width;
    var h = doc.selection[0].height;

    // create a publishing profile for this output with the filename, width and height set
    createProfile(item.linkageIdentifier, w, h, saveDir);

    // cuts the current selection from the document and writes it to the Clipboard.
    doc.clipCut();

    // Create a new temporary document to paste the clip held in the clipboard 
    fl.createDocument();    
        
    // get a handle on the currently focused document (the temporary one)
    exportdoc = fl.getDocumentDOM();
    
    // Setup the document to use the profile we generated for it useing 
    // the tenmplate
    exportdoc.importPublishProfile(profpath);        
    exportdoc.currentPublishProfile = "png";
    
    // pastes the contents of the Clipboard into the document, defaults to 
    // adding it at the center of the document    
    exportdoc.clipPaste();
    
    // Selects all items on the Stage
    exportdoc.selectAll();
    
    // We are only adding one item to each document so we only need to get the 
    // first item in the array of selected items
    var selectedItem = exportdoc.selection[0];
    
    // set the dimensions of the output movie to match the dimensions of our selected clip
    exportdoc.width = Math.floor(w);
    exportdoc.height = Math.floor(h);
    
    // Move the selection to fit the dimensions of the export movie. 
    exportdoc.moveSelectionBy({x:-selectedItem.left, y:-selectedItem.top});
    
    // Deselect the selected item
    exportdoc.selectNone();    
    
    // Publish the current document using the png profile we set up earlier
    exportdoc.publish(); 
    
    // access the document that is currently focused (the temporary one) and
    // close it. Do not promt the user to save changes
    exportdoc.close(false);    
        
    // trace its name in the output panel
    fl.trace('saving:' + pngName);
}

function createProfile(name, w, h, path) {
	profile = 	'<?xml version="1.0"?>\n' + 
	'<flash_profile version="1.0" name="Default">\n' + 
	'  <PublishFormatProperties enabled="true">\n' + 
	'    <defaultNames>0</defaultNames>\n' + 
	'    <flash>0</flash>\n' + 
	'    <generator>0</generator>\n' + 
	'    <projectorWin>0</projectorWin>\n' + 
	'    <projectorMac>0</projectorMac>\n' + 
	'    <html>0</html>\n' + 
	'    <gif>0</gif>\n' + 
	'    <jpeg>0</jpeg>\n' + 
	'    <png>1</png>\n' + 
	'    <qt>0</qt>\n' + 
	'    <rnwk>0</rnwk>\n' + 
	'    <flashDefaultName>0</flashDefaultName>\n' + 
	'    <generatorDefaultName>1</generatorDefaultName>\n' + 
	'    <projectorWinDefaultName>1</projectorWinDefaultName>\n' + 
	'    <projectorMacDefaultName>1</projectorMacDefaultName>\n' + 
	'    <htmlDefaultName>1</htmlDefaultName>\n' + 
	'    <gifDefaultName>1</gifDefaultName>\n' + 
	'    <jpegDefaultName>0</jpegDefaultName>\n' + 
	'    <pngDefaultName>0</pngDefaultName>\n' + 
	'    <qtDefaultName>1</qtDefaultName>\n' + 
	'    <rnwkDefaultName>1</rnwkDefaultName>\n' + 
	'    <flashFileName>' + path + name + '.swf</flashFileName>\n' + 
	'    <generatorFileName>' + path + name + '.swt</generatorFileName>\n' + 
	'    <projectorWinFileName>' + path + name + '.exe</projectorWinFileName>\n' + 
	'    <projectorMacFileName>' + path + name + '.app</projectorMacFileName>\n' + 
	'    <htmlFileName>' + path + name + '.html</htmlFileName>\n' + 
	'    <gifFileName>' + path + name + '.gif</gifFileName>\n' + 
	'    <jpegFileName>' + path + name + '.jpg</jpegFileName>\n' + 
	'    <pngFileName>' + path + name + '.png</pngFileName>\n' + 
	'    <qtFileName>' + path + name + '.mov</qtFileName>\n' + 
	'    <rnwkFileName>' + path + name + '.smil</rnwkFileName>\n' + 
	'  </PublishFormatProperties>\n' + 
	'  <PublishHtmlProperties enabled="true">\n' + 
	'    <VersionDetectionIfAvailable>0</VersionDetectionIfAvailable>\n' + 
	'    <VersionInfo>9,0,115,0;8,0,24,0;7,0,14,0;6,0,79,0;5,0,58,0;4,0,32,0;3,0,8,0;2,0,1,12;1,0,0,1;</VersionInfo>\n' + 
	'    <UsingDefaultContentFilename>1</UsingDefaultContentFilename>\n' + 
	'    <UsingDefaultAlternateFilename>1</UsingDefaultAlternateFilename>\n' + 
	'    <ContentFilename>'+ name + '.html</ContentFilename>\n' + 
	'    <AlternateFilename>'+ name + 'html</AlternateFilename>\n' + 
	'    <UsingOwnAlternateFile>0</UsingOwnAlternateFile>\n' + 
	'    <OwnAlternateFilename></OwnAlternateFilename>\n' + 
    '    <Width>' + w + '</Width>\n'+
    '    <Height>' + h + '</Height>\n'+
	'    <Align>0</Align>\n' + 
	'    <Units>0</Units>\n' + 
	'    <Loop>1</Loop>\n' + 
	'    <StartPaused>0</StartPaused>\n' + 
	'    <Scale>0</Scale>\n' + 
	'    <HorizontalAlignment>1</HorizontalAlignment>\n' + 
	'    <VerticalAlignment>1</VerticalAlignment>\n' + 
	'    <Quality>4</Quality>\n' + 
	'    <WindowMode>0</WindowMode>\n' + 
	'    <DisplayMenu>1</DisplayMenu>\n' + 
	'    <DeviceFont>0</DeviceFont>\n' + 
	'    <TemplateFileName>/Users/abitofcode/Library/Application Support/Adobe/Flash CS3/en/Configuration/HTML/Default.html</TemplateFileName>\n' + 
	'    <showTagWarnMsg>1</showTagWarnMsg>\n' + 
	'  </PublishHtmlProperties>\n' + 
	'  <PublishFlashProperties enabled="true">\n' + 
	'    <TopDown>0</TopDown>\n' + 
	'    <Report>0</Report>\n' + 
	'    <Protect>0</Protect>\n' + 
	'    <OmitTraceActions>0</OmitTraceActions>\n' + 
	'    <Quality>100</Quality>\n' + 
	'    <StreamFormat>0</StreamFormat>\n' + 
	'    <StreamCompress>7</StreamCompress>\n' + 
	'    <EventFormat>0</EventFormat>\n' + 
	'    <EventCompress>7</EventCompress>\n' + 
	'    <OverrideSounds>0</OverrideSounds>\n' + 
	'    <Version>8</Version>\n' + 
	'    <ExternalPlayer></ExternalPlayer>\n' + 
	'    <ActionScriptVersion>1</ActionScriptVersion>\n' + 
	'    <PackageExportFrame>1</PackageExportFrame>\n' + 
	'    <PackagePaths></PackagePaths>\n' + 
	'    <AS3PackagePaths></AS3PackagePaths>\n' + 
	'    <DebuggingPermitted>0</DebuggingPermitted>\n' + 
	'    <DebuggingPassword></DebuggingPassword>\n' + 
	'    <CompressMovie>1</CompressMovie>\n' + 
	'    <FireFox>0</FireFox>\n' + 
	'    <InvisibleLayer>1</InvisibleLayer>\n' + 
	'    <DeviceSound>0</DeviceSound>\n' + 
	'    <StreamUse8kSampleRate>0</StreamUse8kSampleRate>\n' + 
	'    <EventUse8kSampleRate>0</EventUse8kSampleRate>\n' + 
	'    <UseNetwork>0</UseNetwork>\n' + 
	'    <DocumentClass></DocumentClass>\n' + 
	'    <AS3Strict>1</AS3Strict>\n' + 
	'    <AS3Coach>1</AS3Coach>\n' + 
	'    <AS3AutoDeclare>1</AS3AutoDeclare>\n' + 
	'    <AS3Dialect>AS3</AS3Dialect>\n' + 
	'    <AS3ExportFrame>1</AS3ExportFrame>\n' + 
	'    <AS3Optimize>1</AS3Optimize>\n' + 
	'    <ExportSwc>0</ExportSwc>\n' + 
	'    <ScriptStuckDelay>15</ScriptStuckDelay>\n' + 
	'  </PublishFlashProperties>\n' + 
	'  <PublishJpegProperties enabled="true">\n' + 
    '    <Width>' + w + '</Width>\n'+
    '    <Height>' + h + '</Height>\n'+
	'    <Progressive>0</Progressive>\n' + 
	'    <DPI>4718592</DPI>\n' + 
	'    <Size>0</Size>\n' + 
	'    <Quality>80</Quality>\n' + 
	'    <MatchMovieDim>1</MatchMovieDim>\n' + 
	'  </PublishJpegProperties>\n' + 
	'  <PublishRNWKProperties enabled="true">\n' + 
	'    <exportFlash>1</exportFlash>\n' + 
	'    <flashBitRate>0</flashBitRate>\n' + 
	'    <exportAudio>1</exportAudio>\n' + 
	'    <audioFormat>0</audioFormat>\n' + 
	'    <singleRateAudio>0</singleRateAudio>\n' + 
	'    <realVideoRate>100000</realVideoRate>\n' + 
	'    <speed28K>1</speed28K>\n' + 
	'    <speed56K>1</speed56K>\n' + 
	'    <speedSingleISDN>0</speedSingleISDN>\n' + 
	'    <speedDualISDN>0</speedDualISDN>\n' + 
	'    <speedCorporateLAN>0</speedCorporateLAN>\n' + 
	'    <speed256K>0</speed256K>\n' + 
	'    <speed384K>0</speed384K>\n' + 
	'    <speed512K>0</speed512K>\n' + 
	'    <exportSMIL>1</exportSMIL>\n' + 
	'  </PublishRNWKProperties>\n' + 
	'  <PublishGifProperties enabled="true">\n' + 
    '    <Width>' + w + '</Width>\n'+
    '    <Height>' + h + '</Height>\n'+
	'    <Animated>0</Animated>\n' + 
	'    <MatchMovieDim>1</MatchMovieDim>\n' + 
	'    <Loop>1</Loop>\n' + 
	'    <LoopCount></LoopCount>\n' + 
	'    <OptimizeColors>1</OptimizeColors>\n' + 
	'    <Interlace>0</Interlace>\n' + 
	'    <Smooth>1</Smooth>\n' + 
	'    <DitherSolids>0</DitherSolids>\n' + 
	'    <RemoveGradients>0</RemoveGradients>\n' + 
	'    <TransparentOption></TransparentOption>\n' + 
	'    <TransparentAlpha>128</TransparentAlpha>\n' + 
	'    <DitherOption></DitherOption>\n' + 
	'    <PaletteOption></PaletteOption>\n' + 
	'    <MaxColors>255</MaxColors>\n' + 
	'    <PaletteName></PaletteName>\n' + 
	'  </PublishGifProperties>\n' + 
	'  <PublishPNGProperties enabled="true">\n' + 
    '    <Width>' + w + '</Width>\n'+
    '    <Height>' + h + '</Height>\n'+
	'    <OptimizeColors>1</OptimizeColors>\n' + 
	'    <Interlace>0</Interlace>\n' + 
	'    <Transparent>0</Transparent>\n' + 
	'    <Smooth>1</Smooth>\n' + 
	'    <DitherSolids>0</DitherSolids>\n' + 
	'    <RemoveGradients>0</RemoveGradients>\n' + 
	'    <MatchMovieDim>1</MatchMovieDim>\n' + 
	'    <DitherOption>None</DitherOption>\n' + 
	'    <FilterOption>None</FilterOption>\n' + 
	'    <PaletteOption>Web 216</PaletteOption>\n' + 
	'    <BitDepth>24-bit with Alpha</BitDepth>\n' + 
	'    <MaxColors>255</MaxColors>\n' + 
	'    <PaletteName></PaletteName>\n' + 
	'  </PublishPNGProperties>\n' + 
	'  <PublishQTProperties enabled="true">\n' + 
    '    <Width>' + w + '</Width>\n'+
    '    <Height>' + h + '</Height>\n'+
	'    <MatchMovieDim>1</MatchMovieDim>\n' + 
	'    <UseQTSoundCompression>0</UseQTSoundCompression>\n' + 
	'    <AlphaOption></AlphaOption>\n' + 
	'    <LayerOption></LayerOption>\n' + 
	'    <QTSndSettings>00000000</QTSndSettings>\n' + 
	'    <ControllerOption>0</ControllerOption>\n' + 
	'    <Looping>0</Looping>\n' + 
	'    <PausedAtStart>0</PausedAtStart>\n' + 
	'    <PlayEveryFrame>0</PlayEveryFrame>\n' + 
	'    <Flatten>1</Flatten>\n' + 
	'  </PublishQTProperties>\n' + 
	'</flash_profile>\n'

    // Clear the output window
    fl.outputPanel.clear()
    // write the profile xml (above) into the output window
    fl.trace(profile);
    // save the contents of the output window to the path stored in propath
    fl.outputPanel.save(profpath);
    // clear the output window
    fl.outputPanel.clear()
}



