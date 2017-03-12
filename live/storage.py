import time, collections

T = 0.3

class Storage:
    def __init__(self, default_val = "-"):
        self.q = collections.deque()
        self.default_val = default_val

    def clear(self):
        t = time.time()
        while len(self.q) > 0 and self.q[0][0] + T < t:
            self.q.popleft()

    def set(self, val):
        t = time.time()
        self.q.append((t, str(val)))
        self.clear()

    def mx(self):
        s = set([v for t, v in self.q])
        l = [(self.q.count(i), i) for i in s]
        m = max(l)
        return m[1]

    def get(self):
        self.clear()
        if len(self.q) == 0:
            return self.default_val
        return self.mx()
