#!/usr/bin/env ruby

@a = 0.01
@b = 0
@u = -2
@v = 100

def r x
  [[@a * (x - @b), 0].max, 1].min
end

@rmean = 60.0
@rstddev = 15.0
@rtotal = 1
def r x  # normal
  #d = Math.sqrt(2 * Math::PI) * @rstddev
  #@rtotal * Math.exp(-(x - @rmean)**2 / (2 * @rstddev**2)) / d
  (1 + Math.erf((x - @rmean) / @rstddev / Math.sqrt(2))) / 2
end

def n x
  @u * (x - @v)
end

@nmean = 50.0
@nstddev = 15.0
@ntotal = 10000
def n x  # normal
  d = Math.sqrt(2 * Math::PI) * @nstddev
  @ntotal * Math.exp(-(x - @nmean)**2 / (2 * @nstddev**2)) / d
end

def srn x
  sum = 0
  x.upto(@v) { |x| sum += r(x) * n(x) }
  sum
end

def sn x
  sum = 0
  x.upto(@v) { |x| sum += n(x) }
  sum + 0.0000001
end

@b.upto(@v) do |x|
  puts "#{x}  #{n(x).to_i}  #{sn(x).to_i}  #{"%5.1f" % (100 * r(x))}%   #{srn(x).to_i}  #{"%5.1f" % (100 * srn(x)/sn(x))}%"
end
