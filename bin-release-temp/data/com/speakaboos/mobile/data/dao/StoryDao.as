﻿package com.speakaboos.mobile.data.dao{	import com.speakaboos.ipad.events.CoreEventDispatcher;	import com.speakaboos.ipad.events.DBEvents;	import com.speakaboos.ipad.events.GenericDataEvent;	import com.speakaboos.ipad.models.data.Story;	import com.speakaboos.mobile.data.db.connection.ConnectionStruct;		import flash.data.SQLMode;	import flash.data.SQLResult;	import flash.data.SQLStatement;	import flash.errors.IllegalOperationError;	import flash.errors.SQLError;	import flash.net.Responder;
	public class StoryDao extends CoreDao	{		public function StoryDao()		{		}				override public function destroy():void{			//log(this, "destroy");			super.destroy();		}								final private function releaseAndRespondNull(eventType:String, cs:ConnectionStruct):void{			if(cs){releaseConnection(cs);}			CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(eventType, {storyQueryResults:null}));		}				/**********************************************************/				/*			BEGIN insertNewStory()		*/						final public function insertNewStory(story:Story):void		{			//log(this, "insertNewStory");						var getConnection:Function = function(cs:ConnectionStruct):void{				if(cs)					insertStoryIntoDB(cs, story);				else					releaseAndRespondNull(DBEvents.STORY_RESULTS, cs);			};						getDbConn(getConnection, SQLMode.UPDATE);		}								final private function insertStoryIntoDB(cs:ConnectionStruct, story:Story):void{						log(this, "insertStoryIntoDB");			if(cs == null){				//log(this, "Could not obtain DB connection");				releaseAndRespondNull(DBEvents.STORY_RESULTS, cs);				return;			}						//log(this, "obtained DB connection!");						/////////////////////////////////////////////////////////						/* closures */						var onInsert:Function = function(result:SQLResult):void{				//log(this, "insertStoryIntoDB->cbFunc");				assignCategories(result, cs, story);			};						var onOpError:Function = function(err:SQLError):void{				releaseAndRespondNull(DBEvents.STORY_RESULTS, cs);			};						/////////////////////////////////////////////////////////						/* main logic */						//update an existing story of it exists, insert a new one if it doesn't			var stmt:SQLStatement = new SQLStatement();						var subQuery:String = "(select id from stories where slug = :slug), ";			var strSql:String = "INSERT OR REPLACE INTO stories(id, slug, title, category, storyType, thumbnail, freeStory) " +				"values(" + subQuery + ":slug, :title, :category, :storyType, :thumbnail, :freeStory)";									stmt.parameters[':slug'] = story.slug;			stmt.parameters[':title'] = story.title;			stmt.parameters[':category'] = null; // COMING SOON - THANH NEEDS TO ADD THIS TO THE GETSTORIESBYCATEGORY SERVICE			stmt.parameters[':storyType'] = story.storyType;			stmt.parameters[':thumbnail'] = story.storyIcon; //TODO: might want to rename this collumn since this may be confusing... perhaps we move to just storing story slug since we know all the data will be present and could be looked up			stmt.parameters[':freeStory'] = story.freeStory;			stmt.text = strSql;			stmt.sqlConnection = cs.connection;									try{				stmt.execute(-1, new Responder(onInsert,onOpError));			}			catch(err:IllegalOperationError){				//log(this, "IllegalOperationError inserting story: " + err.message);							}					}						final private function assignCategories(result:SQLResult, cs:ConnectionStruct, storyToProcess:Story):void		{				/*				insert categories associated with story into categories table			*/			//log(this, "assignCategories: "+storyToProcess.categories);						///////////////////////////////////////						/* closures */						var onDone:Function = function():void{				releaseConnection(cs);				CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(DBEvents.STORY_ADDED_TO_DB, {story:storyToProcess}));			};						var onAssignCategorySuccess:Function = function(result:SQLResult):void{				doAssignCategories();						};									var onOpError:Function = function(err:SQLError):void{				releaseAndRespondNull(DBEvents.SAVED_STORY_RESULTS, cs);			};						var doAssignCategories:Function = function():void{				if(currCat < max_len){						//log(this, "Assigning category " + storyToProcess.categories[currCat] + " to story " + storyToProcess.slug);					assignStoryToCategory(cs, storyToProcess.slug, storyToProcess.categories[currCat++], onAssignCategorySuccess, onOpError);				}				else{					//log(this, "All categories assigned to story " + storyToProcess.slug);					onDone();				}			};									///////////////////////////////////////						/* main logic */						if(!storyToProcess.categories || !(storyToProcess.categories.length > 0)){				//log(this, "category array is null or empty!  Aborting...");				onDone();				return;			}						var max_len:uint = storyToProcess.categories.length;			var currCat:int = 0;						doAssignCategories();				}						final private function assignStoryToCategory(cs:ConnectionStruct, slug:String, category:String, cbFunc:Function, errFunc:Function):void{			//log(this, "assignStoryToCategory: " + slug + ", cat: " + category);						var stmt:SQLStatement = new SQLStatement();			stmt.sqlConnection = cs.connection;			stmt.text = "INSERT OR REPLACE into categories(id, slug, category) values((SELECT id FROM categories where slug=:slug AND category=:category), :slug, :category)";			stmt.parameters[':slug'] = slug;			stmt.parameters[':category'] = category;			stmt.execute(-1, new Responder(cbFunc, errFunc));		}				/*			END insertNewStory()		*/					/**********************************************************/				/*			BEGIN getStoriesByCategory()		*/		/*			Note: this method replaces 				queryStories(category:String = null, categoryType:String = null)			which has been removed.		*/				final public function getStoriesByCategory(catSlug:String = null):void{			/////////////////////////////////////////////////			var onGotConnection:Function = function(cs:ConnectionStruct):void{								if(!cs){					CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(DBEvents.STORY_RESULTS, {storyQueryResults:null}));					return;				}								doGetStoriesByCategory(cs, catSlug);							};						/////////////////////////////////////////////////						//Get the SQL Connection			getDbConn(onGotConnection, SQLMode.READ);					}						final private function doGetStoriesByCategory(cs:ConnectionStruct, catSlug:String):void{						var onGotStories:Function;			var onOpError:Function;						if(!cs){				CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(DBEvents.STORY_RESULTS, {storyQueryResults:null}));				return;			}						/////////////////////////////////////////////////			onGotStories = function(result:SQLResult):void{				releaseConnection(cs);				onGetStoriesByCategory(result);			};									onOpError = function(err:SQLError):void{				//log(this, err.message);				releaseAndRespondNull(DBEvents.STORY_RESULTS, cs);			};			/////////////////////////////////////////////////						var stmt:SQLStatement = new SQLStatement();						var sql:String = "SELECT * FROM stories";						if(catSlug != null){				stmt.parameters[':slug'] = catSlug;				sql = sql + " JOIN categories ON categories.slug = stories.slug " + 					"WHERE categories.category = :slug";			}						stmt.text = sql;			stmt.sqlConnection = cs.connection;									try{				stmt.execute(-1, new Responder(onGotStories, onOpError));			}			catch(err:IllegalOperationError){				releaseAndRespondNull(DBEvents.STORY_RESULTS, cs);			}			catch(err:SQLError){				releaseAndRespondNull(DBEvents.STORY_RESULTS, cs);			}		}								final private function onGetStoriesByCategory(result:SQLResult):void{						var storyQueryResults:Array = new Array;			var storyListingFromDB:Story;						for each (var obj:Object in result.data) {				storyListingFromDB = new Story(obj);								storyQueryResults.push(storyListingFromDB);			}									CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(DBEvents.STORY_RESULTS, {storyQueryResults:storyQueryResults}));		}				/*			END getStoriesByCategory()		*/						/**********************************************************/						/*			BEGIN getSavedStories()		*/				/*			NOTE: this method replaces querySavedStories(), which has been removed		*/				final public function getSavedStories(fullAccess:Boolean=false, maxStories:int=3):void{					trace("getSavedStories");			var onGotConnection:Function = function(cs:ConnectionStruct):void{				trace("onGotConnection: cs==null" + (cs == null));				if(!cs){					CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(DBEvents.SAVED_STORY_RESULTS, {storyQueryResults:null}));					return;				}								doGetSavedStories(cs, fullAccess, maxStories);			};									//Get the SQL Connection			getDbConn(onGotConnection, SQLMode.READ);		}								final private function doGetSavedStories(cs:ConnectionStruct, fullAccess:Boolean, maxStories:int=3):void{			trace("doGetSavedStories: cs:" + cs + ", fullAccess: " + fullAccess + ", maxStories: " + maxStories);			var onGotSavedStories:Function;			var onOpError:Function;						if(!cs){				CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(DBEvents.SAVED_STORY_RESULTS, {storyQueryResults:null}));				return;			}						/////////////////////////////////////////////////			onGotSavedStories = function(result:SQLResult):void{				trace("onGotSavedStories");				releaseConnection(cs);				//var theResult:SQLResult = stmt.getResult();				//trace(theResult.data);				onGetSavedStories(result);			};									onOpError = function(err:SQLError):void{				trace("doGetSavedStories->onOpError" + err.message);				releaseAndRespondNull(DBEvents.SAVED_STORY_RESULTS, cs);			};						/////////////////////////////////////////////////			var stmt:SQLStatement = new SQLStatement();						var strSort:String = " ORDER BY id ASC";			if(!fullAccess){				strSort += " LIMIT :maxStories";				stmt.parameters[':maxStories'] = maxStories;						}						var strSql:String =  "SELECT * FROM stories" + strSort;						stmt.text = strSql;			stmt.sqlConnection = cs.connection;						trace("sqlString: " + strSql);						try{				stmt.execute(-1, new Responder(onGotSavedStories, onOpError));			}			catch(err:IllegalOperationError){				releaseAndRespondNull(DBEvents.SAVED_STORY_RESULTS, cs);			}			catch(err:SQLError){				releaseAndRespondNull(DBEvents.SAVED_STORY_RESULTS, cs);			}				}						final private function onGetSavedStories(result:SQLResult):void{			//trace("onGetSavedStories: result length: " + result.data.length);			var retVal:Object = null;						if(result.data != null){				retVal = result.data;				}			else			{retVal = [];} //empty array						CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(DBEvents.SAVED_STORY_RESULTS, {storyQueryResults:retVal}));		} 						/*			END getSavedStories()		*/						/**********************************************************/						/*			BEGIN getStoryBySlug()		*/				final public function getStoryBySlug(slug:String):void{						/////////////////////////////////////////////////			var onGotConnection:Function = function(cs:ConnectionStruct):void{								if(!cs){					CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(DBEvents.STORY_RETRIEVED, {storyQueryResults:null}));					return;				}								doGetStoryBySlug(cs, slug);							};			/////////////////////////////////////////////////						//Get the SQL Connection			getDbConn(onGotConnection, SQLMode.READ);		}						final private function doGetStoryBySlug(cs:ConnectionStruct, slug:String):void{						var onGotStory:Function;			var onOpError:Function;						onGotStory = function(result:SQLResult):void{				releaseConnection(cs);				//var theResult:SQLResult = stmt.getResult();				//trace(theResult.data);				onGetStoryBySlug(result);			};									onOpError = function(err:SQLError):void{				releaseAndRespondNull(DBEvents.STORY_RETRIEVED, cs);			};						var stmt:SQLStatement = new SQLStatement();			stmt.parameters[':slug'] = slug;			stmt.text = "SELECT * FROM stories WHERE stories.slug = :slug";			stmt.sqlConnection = cs.connection;						try{				stmt.execute(-1, new Responder(onGotStory, onOpError));			}			catch(err:IllegalOperationError){				releaseAndRespondNull(DBEvents.STORY_RETRIEVED, cs);			}			catch(err:SQLError){				releaseAndRespondNull(DBEvents.STORY_RETRIEVED, cs);			}				}						final private function onGetStoryBySlug(result:SQLResult):void{						var retVal:Object = null;						if(result.data != null){				retVal = result.data[0];				}			CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(DBEvents.STORY_RETRIEVED, {storyQueryResults:retVal}));					} 						/*			END getStoryBySlug()		*/				/**********************************************************/				/*			BEGIN getSavedStoryCount()		*/				final public function getSavedStoryCount():void{						/////////////////////////////////////////////////			var onGotConnection:Function = function(cs:ConnectionStruct):void{								if(!cs){					CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(DBEvents.STORY_COUNT_RETRIEVED, {storyQueryResults:null}));					return;				}								doGetSavedStoryCount(cs);							};			/////////////////////////////////////////////////									//Get the SQL Connection			getDbConn(onGotConnection, SQLMode.READ);						}				final private function doGetSavedStoryCount(cs:ConnectionStruct):void{						var onGotStoryCount:Function;			var onOpError:Function;						onGotStoryCount = function(result:SQLResult):void{				releaseConnection(cs);				//var theResult:SQLResult = stmt.getResult();				//trace(theResult.data);				onGetSavedStoryCount(result);			};									onOpError = function(err:SQLError):void{				releaseAndRespondNull(DBEvents.STORY_COUNT_RETRIEVED, cs);			};						var stmt:SQLStatement = new SQLStatement();			stmt.text = "select count(*) as numStories from stories";			stmt.sqlConnection = cs.connection;						try{				stmt.execute(-1, new Responder(onGotStoryCount, onOpError));			}			catch(err:IllegalOperationError){				releaseAndRespondNull(DBEvents.STORY_COUNT_RETRIEVED, cs);			}			catch(err:SQLError){				releaseAndRespondNull(DBEvents.STORY_COUNT_RETRIEVED, cs);			}					}				final private function onGetSavedStoryCount(result:SQLResult):void{						var retVal:Object = null;						if(result.data != null){				retVal = result.data[0].numStories;				}						CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(DBEvents.STORY_COUNT_RETRIEVED, {storyQueryResults:retVal}));					} 						/*			END getSavedStoryCount()		*/							/**********************************************************/						/*			BEGIN deleteStory()		*/						/**		 *  delete individual items		 */				final public function deleteStory(story:Story):void{						var onGotConnection:Function = function(cs:ConnectionStruct):void{				if(cs)					{doDelete(cs, story);}			};						getDbConn(onGotConnection, SQLMode.UPDATE);									}								final private function doDelete(cs:ConnectionStruct, story:Story):void{						var onDeleteStorySuccess:Function = function(event:SQLResult):void{				//log("onDeleteStorySuccess");				doDeleteStoryFromCategories(cs, story);			};						var onOpError:Function = function(err:SQLError):void{				releaseAndRespondNull(DBEvents.DELETE_STORY_SUCCESS, cs);			};									var stmt:SQLStatement = new SQLStatement();						stmt.parameters[':slug'] = story.slug;			stmt.text = "delete from stories where slug=:slug";			stmt.sqlConnection = cs.connection;			stmt.execute(-1, new Responder(onDeleteStorySuccess, onOpError));				}						final private function doDeleteStoryFromCategories(cs:ConnectionStruct, story:Story):void{						var onDeleteFromCategories:Function = function(event:SQLResult):void{				//log("onDeleteStorySuccess");				releaseConnection(cs);				CoreEventDispatcher.getInstance().dispatchEvent((new GenericDataEvent(DBEvents.DELETE_STORY_SUCCESS,{story:story})));							};						var onOpError:Function = function(err:SQLError):void{				releaseAndRespondNull(DBEvents.DELETE_STORY_SUCCESS, cs);			};									var stmt:SQLStatement = new SQLStatement();						stmt.parameters[':slug'] = story.slug;			stmt.text = "delete from categories where slug=:slug";			stmt.sqlConnection = cs.connection;			stmt.execute(-1, new Responder(onDeleteFromCategories, onOpError));		}				/*			END deleteStory()		*/				/**********************************************************/						/*			BEGIN deleteSavedStories()		*/				final public function deleteSavedStories():void{			getDbConn(doDeleteAllSavedStories, SQLMode.UPDATE);		}						final private function doDeleteAllSavedStories(cs:ConnectionStruct):void{						if(!cs)				{return;}						var onDeleteAll:Function = function(event:SQLResult):void{				doDeleteAllStoriesFromCategories(cs);			};						var onOpError:Function = function(err:SQLError):void{				releaseAndRespondNull(DBEvents.DELETE_SAVED_STORIES_SUCCESS, cs);			};						var stmt:SQLStatement = new SQLStatement();			stmt.parameters[':freeStory'] = false;						stmt.text = "delete from stories where freeStory=:freeStory";;			stmt.sqlConnection = cs.connection;			stmt.execute(-1, new Responder(onDeleteAll, onOpError));				}						final private function doDeleteAllStoriesFromCategories(cs:ConnectionStruct):void{						var onDeleteAllFromCategories:Function = function(event:SQLResult):void{				//log("onDeleteStorySuccess");				releaseConnection(cs);				CoreEventDispatcher.getInstance().dispatchEvent((new GenericDataEvent(DBEvents.DELETE_SAVED_STORIES_SUCCESS)));							};						var onOpError:Function = function(err:SQLError):void{				releaseAndRespondNull(DBEvents.DELETE_SAVED_STORIES_SUCCESS, cs);			};									var stmt:SQLStatement = new SQLStatement();						stmt.text = "delete from categories";			stmt.sqlConnection = cs.connection;			stmt.execute(-1, new Responder(onDeleteAllFromCategories, onOpError));		}				/*			END deleteSavedStories()		*/				}}