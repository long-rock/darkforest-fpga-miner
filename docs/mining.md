# Mining in Dark Forest

Dark Forest players start the game with an empty map of the universe.  The goal
is to conquer as many planets as possible and extract resources from them.
Exploring is done by computing the hash of each `(x, y)` coordinate in the game,
this process is also known as "mining". The hash of a coordinate determines if
and what type of celestial body (planets, asteroid fields, foundries) is present
and that point.

A miner's job is to compute the hashes of all coordinates within a "chunk" of
space, filter out the hashes that don't contain a celestial body, and then send
back the list of celestial bodies to the client. A point in space contains a
celestial body if its hash is less than some threshold provided by the client.


## Dark Forest Hashing

Dark Forest uses the [MiMC hashing function](https://byt3bit.github.io/primesym/).
All operations are in `𝔽_q`, where `q` is a prime number defined by the game. The 
random key `k ∈ 𝔽_q` is also provided by the game client and is constant for the duration
of a game's round. The round constants `c_i ∈ 𝔽_q` are also constants, and for now are
hard-coded in the game and miners.


## Hashing Implementation

The algorithm uses a sponge design to implement the MiMC hashing function.

```python
def hash(x, y, key):
    sponge = Sponge()

    sponge.inject(x)
    sponge.mix(key)

    sponge.inject(y)
    sponge.mix(key)

    return sponge.output()
```

The sponge state is stored using two variables `l` and `r` that are initialized to 0.
The inject method simply adds the given value to the state variable `l`, the addition
is in the field `𝔽_q`.

```python
class Sponge:
    def inject(self, v):
        self.l += v
```

The mix method updates the state using round constants and the random key. Again, all
operations (including the power operator) are in the field `𝔽_q`.

```python
class Sponge:
    def mix(self, key):
        for c_i in c:
            t = k + self.l + c
            l_ = t**5 + self.r
            self.r = self.l
            self.l = l_
        t = k + self.l
        self.r = t**5 + self.r
```

The output of the sponge is the value of state variable `l`.

The bit-size of the numbers depends on the value of the prime `q`, the current
implementation uses 256-bit numbers to perform all computations.


## A small optimization

Notice that to compute the hashes of a given chunk we would employ code similar to the following:

```python
for x in chunk.xs:
    for y in chunk.ys:
        h = hash(x, y, key)
```

The MiMC hashing function first computes the hash at the given `x`, then updates
its state with the hash at `y`. We reduce the computational complexity by computing
the hash at `x` once and then store the two state variables before updating the sponge
with the hash at `y`.

```python
def hash_chunk(chunk, key):
    sponge = Sponge()
    for x in chunk.xs:
        sponge.inject(x)
        sponge.mix(key)
        sponge.save()
        for y in chunk.ys:
            sponge.restore()
            sponge.inject(y)
            sponge.mix(key)
            h = sponge.output()
```

This optimization nearly doubles the hash rate of blue-space CPU and GPU miners.


## Resources

 - [blue-space](https://github.com/long-rock/blue-space/), a CPU and GPU miner.
 - [darkforest-rs](https://github.com/projectsophon/darkforest-rs), a CPU miner implemented in Rust.
 - [df-explorer](https://github.com/guild-w/df-explorer), another GPU miner.