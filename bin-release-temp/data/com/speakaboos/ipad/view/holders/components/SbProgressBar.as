package com.speakaboos.ipad.view.holders.components {
	import flash.display.MovieClip;

	public class SbProgressBar extends ProgressBar {
		public static const COMP_FOR_BOOK_WIDTH_INDEX:int = 0;
		public static const CHECK_UPDATE_INDEX:int = 1;
		public static const GET_CATS_PROG_INDEX:int = 2;
		public static const GET_STORIES_PROG_INDEX:int = 3;
		public static const GET_MEDIA_PROG_INDEX:int = 4; //all the media, so will need to divide by number collected...
		public static const GET_DATA_PROG_INDEX:int = 5;
		public static const DB_VERIFICATION_PROG_INDEX:int = 6;
		public static const CHECK_SESSION_PROG_INDEX:int = 7;
		public static const UPDATE_SAVED_INDEX:int = 8;
		public static const PROG_TYPE_COUNT:int = UPDATE_SAVED_INDEX+1;

		public function SbProgressBar() {
			super(new ProgressBarMC() as MovieClip);
			init();
		}
		
		private function init():void {
			var progs:Array = new Array(PROG_TYPE_COUNT);
			progs[COMP_FOR_BOOK_WIDTH_INDEX] = 5;
			progs[CHECK_UPDATE_INDEX] = 5;
			progs[GET_CATS_PROG_INDEX] = 10;
			progs[GET_STORIES_PROG_INDEX] = 30;
			progs[GET_MEDIA_PROG_INDEX] = 40; //all the media, so will need to divide by number collected...
			progs[GET_DATA_PROG_INDEX] = 10;
			progs[DB_VERIFICATION_PROG_INDEX] = 5;
			progs[CHECK_SESSION_PROG_INDEX] = 10;
			progs[UPDATE_SAVED_INDEX] = 5;
			initProgStats(progs);
			_progStats[COMP_FOR_BOOK_WIDTH_INDEX][TOTAL_TYPE] = 1;
			updateProgress(COMP_FOR_BOOK_WIDTH_INDEX, COMPLETED_TYPE, 1);
		}
	}
}