package com.miniGame.managers.math
{
	import mx.utils.StringUtil;

    public class TimeUtil {

        private var _totalMilliseconds:Number

        public static const MILLISECONDS_IN_DAY:Number = 86400000;
        public static const MILLISECONDS_IN_HOUR:Number = 3600000;
        public static const MILLISECONDS_IN_MINUTE:Number = 60000;
        public static const MILLISECONDS_IN_SECOND:Number = 1000;

        public function TimeUtil(milliseconds:Number){
            super();
            this._totalMilliseconds = Math.floor(milliseconds);
        }
		
		public function formatByZero(value:int):String
		{
			var valueStr:String = value + "";
			if(value < 10)
			{
				valueStr = "0" + valueStr;
			}
			
			return valueStr;
		}
		
		public function get formatString2():String
		{
			return (StringUtil.substitute("{0}:{1}", formatByZero(this.minutes), formatByZero(this.seconds)));
		}
        public function get formatString():String{
            return (StringUtil.substitute("{0}:{1}:{2}", this.hours, this.minutes, this.seconds));
        }
        public function get days():int{
            return (int((this._totalMilliseconds / MILLISECONDS_IN_DAY)));
        }
        public function get hours():int{
            return ((int((this._totalMilliseconds / MILLISECONDS_IN_HOUR)) % 24));
        }
        public function get minutes():int{
            return ((int((this._totalMilliseconds / MILLISECONDS_IN_MINUTE)) % 60));
        }
        public function get seconds():int{
            return ((int((this._totalMilliseconds / MILLISECONDS_IN_SECOND)) % 60));
        }
        public function get milliseconds():int{
            return ((int(this._totalMilliseconds) % 1000));
        }
        public function get totalDays():Number{
            return ((this._totalMilliseconds / MILLISECONDS_IN_DAY));
        }
        public function get totalHours():Number{
            return ((this._totalMilliseconds / MILLISECONDS_IN_HOUR));
        }
        public function get totalMinutes():Number{
            return ((this._totalMilliseconds / MILLISECONDS_IN_MINUTE));
        }
        public function get totalSeconds():Number{
            return ((this._totalMilliseconds / MILLISECONDS_IN_SECOND));
        }
        public function get totalMilliseconds():Number{
            return (this._totalMilliseconds);
        }
        public function add(date:Date):Date{
            var ret:Date = new Date(date.time);
            ret.milliseconds = (ret.milliseconds + this.totalMilliseconds);
            return (ret);
        }

        public static function fromDates(start:Date, end:Date):TimeUtil{
            return (new TimeUtil((end.time - start.time)));
        }
        public static function fromMilliseconds(milliseconds:Number):TimeUtil{
            return (new TimeUtil(milliseconds));
        }
        public static function fromSeconds(seconds:Number):TimeUtil{
            return (new TimeUtil((seconds * MILLISECONDS_IN_SECOND)));
        }
        public static function fromMinutes(minutes:Number):TimeUtil{
            return (new TimeUtil((minutes * MILLISECONDS_IN_MINUTE)));
        }
        public static function fromHours(hours:Number):TimeUtil{
            return (new TimeUtil((hours * MILLISECONDS_IN_HOUR)));
        }
        public static function fromDays(days:Number):TimeUtil{
            return (new TimeUtil((days * MILLISECONDS_IN_DAY)));
        }
    }
}