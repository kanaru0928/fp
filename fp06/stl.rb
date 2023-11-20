# frozen_string_literal: false

require 'matrix'
require_relative 'lambertian'
require_relative 'triangle'
require_relative 'color'

#
# STLモデルを扱うクラス
#
class Stl
  attr_accessor :name, :length, :triangles

  def initialize(file_name)
    @file_name = file_name
    @file = File.open(file_name)
    @buffer = ''
    @file.read(nil, @buffer)
    @pointer = 84
    @name = @buffer.unpack1('A80')
    @length = @buffer.unpack1('I', offset: 80)
    @triangles = Array.new(@length)
  end

  def parse(offset, scale)
    @length.times do |i|
      data = @buffer.unpack('f12', offset: @pointer)

      normal = Vector[data[0], data[2], data[1]]
      p0 = p(p(Vector[data[3], -data[5], data[4]]) * scale) + offset
      p1 = (Vector[data[6], -data[8], data[7]] * scale) + offset
      p2 = (Vector[data[9], -data[11], data[10]] * scale) + offset

      @triangles[i] = Triangle.new(p0, p1, p2, Lambertian.new(Colors::GRAY), -normal)
      @pointer += (12 << 2) + 2
    end
  end
end
