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

import flash.display.Sprite;
import flash.text.TextField;
import hxmikmod.event.TrackerEvent;
import hxmikmod.event.TrackerEventDispatcher;
import hxmikmod.MikMod;
import hxmikmod.Player;
import nme.Assets;


/* Load and play a module (My Little Ponies by Radix) embedded as a resource. */



class Main extends Sprite {

   public function new() {
	super();
	var tf=new TextField();
	tf.text="hxMikMod";
	addChild(tf);
   }



   function init() {
	MikMod.Init(null);
	TrackerEventDispatcher.addEventListener(TrackerLoadingEvent.TYPE,onTrackerLoading);
	//Player.LoadBytes(haxe.Resource.getBytes("mylittle.mod").getData(),32,false);
	Player.LoadBytes(Assets.getBytes("assets/mylittle.mod"),32,false);
   }


   // This will be called several times during the loading process.
   // state=LOADED when the module is ready to be played.

   public function onTrackerLoading(e:TrackerLoadingEvent) {
	if (e.state==TrackerLoadingEvent.LOADED)
		Player.Start(e.module);
   }



   public static function main() {
	var p=new Main();
	flash.Lib.current.addChild(p);
	p.init();
   }



}
