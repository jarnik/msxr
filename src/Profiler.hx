/**
 *
 * hxMikMod sound library
 * Copyright (C) 2011 Jouko Pynnönen <jouko@iki.fi>
 *             
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 */

import flash.text.TextField;



// This class can be used to approximate how much time
// different parts of the code use.
//
// Insert Profiler.ENTER(); in the beginning of the method you want to
// examine and Profiler.LEAVE(); in the end.
//
// The Summary() method will dump the calculations in a textfield.
//
// Note: you must call Profiler.LEAVE() before every return statement,
// otherwise the calculation will be wrong. There's no error checking.
// Note2: measuring time of recursive methods won't work, i.e. if
// Profiler.ENTER() is called twice without a LEAVE(), the first enter
// timestamp is lost.



class Profiler {
  static var entertime:Hash<Int>=new Hash();
  static var totaltime:Hash<Int>=new Hash();
  static var called:Hash<Int>=new Hash();
  static var profiling_started=0;

  inline static var UNPROFILED="(unprofiled time) ";
#if PROFILING
  inline static var PROFILER_ENABLED=true;
#else
  inline static var PROFILER_ENABLED=false;	// compiler SHOULD optimize all overhead away if disabled?
#end

  public static function reset() {
	totaltime=new Hash();
	entertime=new Hash();
	profiling_started=flash.Lib.getTimer();
  }


  inline public static function ENTER(?pos:haxe.PosInfos):Void {
	if (PROFILER_ENABLED) {
	   var m=pos.className+"."+pos.methodName;
	   var t=flash.Lib.getTimer();
	   entertime.set(m,t);
	   called.set(m,called.get(m)+1);
	}
  }

  inline public static function LEAVE(?pos:haxe.PosInfos):Void {
	if (PROFILER_ENABLED) {
	   var t=flash.Lib.getTimer();
	   var m=pos.className+"."+pos.methodName;
	   var d=t-entertime.get(m);
	   totaltime.set(m,totaltime.get(m)+d);
	}
  }

  public static function Summary(tf:TextField):Void {
	var alltime=flash.Lib.getTimer()-profiling_started;	// total real time passed ms
	var t="<font face=\"courier,mono,courier new,typewriter,_typewriter\"><pre>";
	var totalms=0;						// time spent inside profiled code
	var longest=0;
	for (m in totaltime.keys()) {
	   totalms+=totaltime.get(m);
	   var len=m.length;
	   if (len>longest) longest=len;
	}
	if (totalms==0) return;
	longest+=4;
	for (m in totaltime.keys()) {
	   var ms=totaltime.get(m);
	   t+=m;
	   for (i in m.length ... longest) t+=" ";
	   t+=""+ms+"ms/"+Math.round(100*ms/totalms)+"% "+called.get(m)+"\n";
	}
	var unprofiled=alltime-totalms;
	t+="\n"+UNPROFILED;
	for (i in UNPROFILED.length ... longest) t+=" ";
	t+=unprofiled+"ms/"+Math.round(100*unprofiled/alltime)+"%\n";
	t+="\n\n</pre></font><font face=\"Times New Roman\" size=\"10\"><b>hxMikMod alpha\n<br>jouko@iki.fi</b></font>";
	tf.htmlText=t;
  }

}
