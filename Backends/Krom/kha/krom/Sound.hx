package kha.krom;

import haxe.io.Bytes;

using StringTools;

class Sound extends kha.Sound {
	public function new(filename: String) {
		super();

		var sound = Krom.loadSound(filename);
		if (sound != null) {
			var bytes = Bytes.ofData(sound);
			var count = Std.int(bytes.length / 4);
			uncompressedData = new kha.arrays.Float32Array(count);
			for (i in 0...count) {
				uncompressedData[i] = bytes.getFloat(i * 4);
			}
		}

		var blob = Krom.loadBlob(filename);
		if (blob != null) {
			var raw = Bytes.ofData(blob);
			if (filename.endsWith(".wav")) {
				parseWavHeader(raw);
			}
			else if (filename.endsWith(".ogg")) {
				parseOggHeader(raw);
			}
		}

		if (sampleRate > 0 && uncompressedData != null) {
			length = (uncompressedData.length / 2) / sampleRate;
		}
	}

	function parseWavHeader(raw: Bytes) {
		if (raw.length >= 28) {
			channels = raw.getUInt16(22);
			sampleRate = raw.getInt32(24);
		}
	}

	function parseOggHeader(raw: Bytes) {
		for (i in 0...raw.length - 16) {
			// Vorbis identification header: 0x01 + "vorbis"
			if (raw.get(i) == 0x01 && raw.get(i + 1) == 0x76 && raw.get(i + 2) == 0x6F
				&& raw.get(i + 3) == 0x72 && raw.get(i + 4) == 0x62
				&& raw.get(i + 5) == 0x69 && raw.get(i + 6) == 0x73) {
				channels = raw.get(i + 11);
				sampleRate = raw.getInt32(i + 12);
				break;
			}
		}
	}

	override public function uncompress(done: Void->Void): Void {
		done();
	}
}
