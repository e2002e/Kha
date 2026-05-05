package kha.krom;

import haxe.io.Bytes;

using StringTools;

class Sound extends kha.Sound {
	public function new(filename: String) {
		super();

		var sound = Krom.loadSound(filename);
		if (sound != null) {
			var bytes = Bytes.ofData(sound.buffer);
			var count = Std.int(bytes.length / 4);
			uncompressedData = new kha.arrays.Float32Array(count);
			for (i in 0...count) {
				uncompressedData[i] = bytes.getFloat(i * 4);
			}

			this.sampleRate = sound.sampleRate;
			this.channels = sound.channels;
			this.length = sound.length;
		}
	}

	override public function uncompress(done: Void->Void): Void {
		done();
	}
}
