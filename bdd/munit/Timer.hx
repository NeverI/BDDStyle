/****
* Copyright 2013 Massive Interactive. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
*
*    1. Redistributions of source code must retain the above copyright notice, this list of
*       conditions and the following disclaimer.
*
*    2. Redistributions in binary form must reproduce the above copyright notice, this list
*       of conditions and the following disclaimer in the documentation and/or other materials
*       provided with the distribution.
*
* THIS SOFTWARE IS PROVIDED BY MASSIVE INTERACTIVE ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL MASSIVE INTERACTIVE OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Massive Interactive.
****/

/*
 * Copyright (c) 2005, The haXe Project Contributors
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE HAXE PROJECT CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE HAXE PROJECT CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */
package bdd.munit;

#if neko
import neko.vm.Thread;
#elseif cpp
import cpp.vm.Thread;
#end

@:expose('bdd.munit.Timer')
class Timer
{
	#if (php)
	public function new(time_ms:Int) {}
	public static function delay(f:Dynamic->Void, time_ms:Int):Timer { return new Timer(0); }
	public function stop(){};
	#else

	private var id:Null<Int>;

	#if (neko||cpp)
	private var runThread:Thread;
	#end

	public function new(time_ms:Int)
	{
		var me = this;
		var timerCallback = function() { me.run(); };
		#if flash9
			id = untyped __global__["flash.utils.setInterval"](timerCallback,time_ms);
		#elseif flash
			id = untyped _global["setInterval"](timerCallback,time_ms);
		#elseif js
			id = untyped setInterval(timerCallback,time_ms);
		#elseif (neko||cpp)
			runThread = Thread.create(function() { me.runLoop(time_ms); } );
		#else php
			timerCallback();
		#end
	}

	public function stop()
	{
		#if( php || flash9 || flash || js )
			if (id == null) return;
		#end
		#if flash9
			untyped __global__["flash.utils.clearInterval"](id);
		#elseif flash
			untyped _global["clearInterval"](id);
		#elseif js
			untyped clearInterval(id);
		#elseif (neko||cpp)
			run = function() {};
			runThread.sendMessage("stop");
		#end
		id = null;
	}

	public dynamic function run()
	{}

	#if (neko||cpp)
	private function runLoop(time_ms)
	{
		var shouldStop = false;
		while( !shouldStop )
		{
			Sys.sleep(time_ms/1000);
			try
			{
				run();
			}
			catch( ex:Dynamic )
			{
				trace(ex);
			}

			var msg = Thread.readMessage(false);
			if (msg == "stop") shouldStop = true;
		}
	}
	#end

	public static function delay(f:Dynamic->Void, time_ms:Int):Timer
	{
		var t = new Timer(time_ms);
		t.run = function()
		{
			t.stop();
			f({});
		};
		return t;
	}
	#end

	/**
	 *	Returns a timestamp, in seconds
	 */
	public static function stamp():Float
	{
		#if flash
			return flash.Lib.getTimer() / 1000;
		#elseif (neko || cpp)
			return Sys.time();
		#elseif php
			return Sys.time();
		#elseif js
			return Date.now().getTime() / 1000;
		#elseif cpp
			return untyped __time_stamp();
		#else
			return 0;
		#end
	}
}
