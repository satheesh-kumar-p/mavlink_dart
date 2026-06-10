import 'dart:convert';

class CrcX25 {
  int _crc = 0xffff;

  void accumulate(int b) {
    b &= 0xff;
    int tmp = b ^ (_crc & 0xff);
    tmp &= 0xff;
    tmp ^= (tmp << 4) & 0xff;
    _crc = ((_crc >> 8) ^
            ((tmp << 8) & 0xffff) ^
            ((tmp << 3) & 0xffff) ^
            (tmp >> 4)) &
        0xffff;
  }

  void accumulateBytes(List<int> bytes) {
    for (final b in bytes) {
      accumulate(b);
    }
  }

  void accumulateString(String str) {
    accumulateBytes(utf8.encode(str));
  }

  int get crc => _crc & 0xffff;
}
