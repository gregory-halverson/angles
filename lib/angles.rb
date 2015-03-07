require "angles/version"

require 'ratapprox'

class Angle
  # make class comparable
  include Comparable

  # make mode and display attributes mutable
  attr_reader :angle
  attr_accessor :mode, :display

  # constants
  @@PI = Math::PI
  @@TWO_PI = Math::PI * 2
  @@PI_SYMBOL = "\u03c0"
  @@DEGREE_SYMBOL = "\u00b0"
  @@SECONDS_DECIMAL_PLACES = 2
  @@ROUND_SECONDS = 10
  @@ROUND_TRIG = 12

  # initializers

  def initialize(angle=0, mode=:degrees, display=:readable)
    @mode = mode
    @display = display

    case mode
      when :degrees
        self.from_radians Angle.normalize_radians(Angle.degrees_to_radians(angle))
      when :radians
        self.from_radians Angle.normalize_radians angle
    end
  end

  def from_degrees(degrees)
    @angle = Angle.normalize_radians(Angle.degrees_to_radians(degrees))
    self
  end

  def from_radians(radians)
    @angle = Angle.normalize_radians(radians)
    self
  end

  # getters

  def radians
    self.angle
  end

  def radians=(radians)
    self.from_radians radians
  end

  def degrees
    Angle.radians_to_degrees(self.radians).to_f
  end

  def degrees=(degrees)
    self.from_degrees degrees
  end

  def d
    self.degrees.floor
  end

  def d=(degrees)
    self.degrees = self.degrees - self.d + degrees
  end

  def minutes
    self.degrees * 60
  end

  def minutes=(minutes)
    self.from_degrees minutes.to_f / 60
  end

  def m
    self.minutes.floor % 60
  end

  def m=(minutes)
    self.minutes = self.minutes - self.m + minutes
  end

  def seconds
    (self.minutes * 60).round @@ROUND_SECONDS
  end

  def seconds=(seconds)
    self.from_degrees seconds.to_f / 3600
  end

  def s
    (self.seconds % 60).round @@ROUND_SECONDS
  end

  def s=(seconds)
    self.seconds = self.seconds - self.s + seconds
  end

  # normalize a value of degrees to [0, 360)
  def self.normalize_degrees(degrees)
    degrees -= 360 while degrees >= 360
    degrees += 360 while degrees < 0
    degrees
  end

  # normalize a value of radians to [0, 2pi)
  def self.normalize_radians(radians)
    radians -= @@TWO_PI while radians >= @@TWO_PI
    radians += @@TWO_PI while radians < 0
    radians
  end

  # convert degrees as float to radians as float
  def self.degrees_to_radians(degrees)
    Angle.normalize_radians(degrees.to_f * @@PI / 180)
  end

  # convert radians as float to degrees as float
  def self.radians_to_degrees(radians)
    Angle.normalize_degrees(radians.to_f * 180 / @@PI)
  end

  # convert degrees as float to degrees, minutes, seconds
  def self.degrees_to_sexagesimal(degrees)
    degrees = Angle.normalize_degrees(degrees.to_f)
    degrees, remainder = degrees.to_f.modf
    remainder = remainder.round(9)
    minutes, seconds = (remainder * 60).modf
    seconds *= 60
    return degrees, minutes, seconds
  end

  # convert degrees, minutes, seconds to degrees as float
  def self.sexagesimal_to_degrees(degrees, minutes, seconds)
    degrees = Angle.normalize_degrees(degrees.to_f)
    degrees + minutes.to_f / 60.0 + seconds.to_f / 3600.0
  end

  # convert degrees as float to coefficient of pi as rational
  def self.degrees_to_coefficient(degrees)
    Angle.radians_to_coefficient(Angle.degrees_to_radians(degrees))
  end

  # convert coefficient of pi as rational to degrees as float
  def self.coefficient_to_degrees(coefficient)
    Angle.normalize_degrees(coefficient.to_f * 180.0)
  end

  # convert radians as float to coefficient of pi as rational
  def self.radians_to_coefficient(radians)
    (radians.to_f / @@PI).to_r
  end

  # convert coefficient of pi as rational to radians as float
  def self.coefficient_to_radians(coefficient)
    Angle.normalize_radians(coefficient.to_f * @@PI)
  end

  # trig functions

  def sin
    sin = Math.sin(self.radians).round(@@ROUND_TRIG)
    (sin == 0) ? 0 : sin
  end

  alias sine sin
  alias jiba sin

  def cos
    cos = Math.cos(self.radians).round(@@ROUND_TRIG)
    (cos == 0) ? 0 : cos
  end

  alias cosine cos

  def tan
    return nil if self.radians == @@PI / 2 or self.radians == 3 * @@PI / 2

    tan = Math.tan(self.radians).round(@@ROUND_TRIG)
    (tan == 0) ? 0 : tan
  end

  alias tangent tan
  alias slope tan

  def csc
    return nil if self.radians == 0 or self.radians == @@PI

    1 / self.sin
  end

  alias cosecant csc

  def sec
    return nil if self.radians == @@PI / 2

    1 / self.cos
  end

  alias secant sec

  def cot
    return nil if self.radians == 0 or self.radians == @@PI
    return 0 if self.radians == @@PI / 2

    1 / self.tan
  end

  alias cotangent cot

  def crd
    2 * (self / 2).sin
  end

  alias chord crd

  def versin
    1 - self.cos
  end

  def vercosin
    1 + self.cos
  end

  def coversin
    1 - self.sin
  end

  def covercosin
    1 + self.sin
  end

  def haversin
    self.versin / 2
  end

  def havercosin
    self.vercosin / 2
  end

  def hacoversin
    self.coversin / 2
  end

  def hacovercosin
    self.covercosin / 2
  end

  def exsec
    self.sec - 1
  end

  def exsecant
    self.exsec
  end

  def excsc
    self.csc - 1
  end

  # inverse trig functions

  def self.asin(x)
    Angle.new.from_radians(Math.asin(x))
  end

  def self.acos(x)
    Angle.new.from_radians(Math.acos(x))
  end

  def self.atan(x)
    Angle.new.from_radians(Math.atan(x))
  end

  def self.asec(x)
    return nil if x == 0

    acos(1 / x)
  end

  def self.acsc(x)
    return nil if x == 0

    asin(1 / x)
  end

  def self.acot(x)
    degrees(90) - atan(x)
  end

  def self.atan2(y, x)
    Angle.new.from_radians(Math.atan2(y, x))
  end

  # trigonometric properties of angle

  def acute?
    self.degrees < 90
  end

  def right?
    self.degrees == 90
  end

  def obtuse?
    d = self.degress
    d > 90 and d < 180
  end

  def straight?
    self.degrees == 180
  end

  def reflex?
    d = self.degrees
    d > 180 and d < 360
  end

  def full?
    self.degrees == 0
  end

  def oblique?
    not [0, 90, 180, 270].include? self.degrees
  end

  # output and type conversions

  def to_s_deg
    case @display
      when :readable
        degrees = Angle.radians_to_degrees(self.radians.round(10))
        degrees, minutes, seconds = Angle.degrees_to_sexagesimal(degrees)
        seconds = seconds.round(@@SECONDS_DECIMAL_PLACES)

        output = ''
        output += (@angle < 0 ? '-' : '')
        output += "#{degrees}" + @@DEGREE_SYMBOL

        if minutes > 0 or seconds > 0
          output += "%02.0f" % minutes
          output += "\'"

          if seconds > 0
            seconds, remainder = seconds.modf
            remainder = remainder.round(@@SECONDS_DECIMAL_PLACES)

            if remainder >= 1
              seconds += Integer(remainder).to_f
              remainder -= Integer(remainder).to_f
            end

            output += "%02.0f" % seconds

            if not (remainder == 0 or (remainder.abs < (10.0 ** -@@SECONDS_DECIMAL_PLACES)))
              output += ("#{remainder.round(@@SECONDS_DECIMAL_PLACES)}"[1..-1])
            end

            output += "\""
          end
        end

        return output
      when :decimal
        return Angle.radians_to_degrees(self.radians).to_s
      else
        return Angle.radians_to_degrees(self.radians).to_s
    end
  end

  def to_s_rad
    case @display
      when :readable
        coefficient = Angle.radians_to_coefficient(self.radians.round(10))

        return '0' if coefficient.numerator == 0

        output = ''
        output += '-' if @angle < 0
        output += "#{coefficient.numerator}" if coefficient.numerator.abs != 1
        output += @@PI_SYMBOL
        output += "/#{coefficient.denominator}" if coefficient.denominator.abs != 1

        return output
      when :decimal
        self.radians.to_f.to_s
      else
        self.radians.to_f.to_s
    end
  end

  def to_s
    case @mode
      when :degrees
        return to_s_deg
      when :radians
        return to_s_rad
      else
        return to_s_deg
    end
  end

  def to_f
    case @mode
      when :degrees
        return Angle.radians_to_degrees(self.radians).round(12)
      when :radians
        return self.radians
      else
        return Angle.radians_to_degrees self.radians
    end
  end

  def to_r
    Angle.radians_to_coefficient(self.radians) / 2
  end

  def to_degrees
    Angle.new(Angle.radians_to_degrees(self.radians), mode=:degrees, display=@display)
  end

  def to_radians
    Angle.new(self.radians, mode=:radians, display=@display)
  end

  def abs
    new_angle = self.clone
    new_angle.from_radians new_angle.angle.abs
    new_angle
  end

  def abs!
    @angle = @angle.abs
  end

  # operator overloads

  def +(other_angle)
    self.clone.from_radians(Angle.normalize_radians(self.radians + other_angle.angle))
  end

  def -(other_angle)
    self.clone.from_radians(Angle.normalize_radians(self.radians - other_angle.angle))
  end

  def *(number)
    self.clone.from_radians(Angle.normalize_radians(self.radians * number))
  end

  def /(number)
    self.clone.from_radians(Angle.normalize_radians(self.radians / number))
  end

  # add comparison operators
  def <=>(other_angle)
    self.angle <=> other_angle.angle
  end

end

def degrees(degrees)
  Angle.new degrees, mode=:degrees
end

def sexagesimal(degrees, minutes, seconds)
  Angle.new(Angle.sexagesimal_to_degrees(degrees, minutes, seconds), mode=:degrees)
end

def radians(radians)
  Angle.new radians, mode=:radians
end
