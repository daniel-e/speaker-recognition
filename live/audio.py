import sys, struct

class Audio:
    class RawData:
        def __init__(self, v, bits = 16):
            self.v = v
            self.bits = bits

        def as_int_vec(self):
            assert(len(self.v) % 2 == 0)
            assert(struct.calcsize("h") == 2)
            return [struct.unpack_from("h", self.v, off)[0] for off in range(0, len(self.v), 2)]

        def as_float_vec(self):
            mx = (1 << (self.bits - 1))
            return [float(i) / mx for i in self.as_int_vec()]

    def __init__(self, rate, bits = 16):
        self.rate = rate
        self.bits = bits
        self.channels = 1
        assert(bits % 8 == 0 and bits > 0)

    def recv(self, winlen_ms, f = sys.stdin.buffer):
        n = self.rate * self.channels * int(self.bits / 8)
        n = int(n * winlen_ms / 1000)
        r = f.read(n)
        assert (len(r) == n)
        return self.RawData(r, self.bits)
