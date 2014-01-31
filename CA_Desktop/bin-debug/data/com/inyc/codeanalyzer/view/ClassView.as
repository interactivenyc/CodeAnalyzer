package com.inyc.codeanalyzer.view
{
	import com.inyc.codeanalyzer.models.ClassItem;
	import com.inyc.components.accordion.Accordion;
	import com.inyc.core.CoreMovieClip;
	
//	import com.yahoo.astra.fl.controls.Tree;
//	import com.yahoo.astra.fl.controls.treeClasses.TreeDataProvider;
	
	import flash.events.Event;
	
	
	public class ClassView extends CoreMovieClip
	{
		private var _classItem:ClassItem;
		private var _accordion:Accordion;
		
		public static const WIDTH:int = 180;
		public static const HEIGHT:int = 120;
		
		public function ClassView(classItem:ClassItem){
			super();
			_classItem = classItem;
		}
		
		override protected function onAddedToStage(e:Event):void{
			super.onAddedToStage(e);
			
			addAccordion();
			//addTree();
		}
		
		override protected function onRemovedFromStage(e:Event):void{
			super.onRemovedFromStage(e);
		}
		
		private function addAccordion():void{
			_accordion = new Accordion();
			_accordion.headerText = _classItem.name;
			addChild(_accordion);
			
			//_accordion.addSection("imports", _classItem.getImportsArray());
			_accordion.addSection("variables", _classItem.getVariablesArray());
			_accordion.addSection("functions", _classItem.getFunctionsArray());

		}
		
		
//		private function addTree():void{
//			var tree:Tree = new Tree();
//			tree.dataProvider = fakeTreeData();
//			addChild(tree);
//			
//		}
		
//		private function addList():void{
//			var dataGrid:DataGrid = new DataGrid();
//			dataGrid.dataProvider = fakeTreeData();
//			addChild(dataGrid);
//			
//		}
		
//		private function fakeTreeData():TreeDataProvider{
//			var myxml:XML = 
//				<node label="Root Node">
//					<node label="Work Documents">
//						<node label="Project.doc"/>
//						<node label="Calendar.doc"/>
//						<node label="Showcase.ppt"/>
//						<node label="Statistics.xls"/>
//					</node>
//					<node label="Personal Docs">
//						<node label="Taxes for 2006.pdf"/>
//						<node label="Investments.xls"/>
//						<node label="Schedule.doc"/>
//					</node>
//					<node label="Photos">
//						<node label="Vacation">
//							<node label="Coliseum.jpg"/>
//							<node label="Vatican.jpg"/>
//						</node>
//						<node label="Football game">
//							<node label="Block.jpg"/>
//							<node label="High jump.jpg"/>
//						</node>
//					</node>
//				</node>;
//			
//			var dataProvider:TreeDataProvider = new TreeDataProvider(myxml);
//			
//			return dataProvider;
//		}
		
	}
}