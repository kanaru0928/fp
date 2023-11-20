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

  #
  # コンストラクタ
  #
  # @param [String] file_name ファイル名
  #
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

  #
  # ファイルからShapeを生成
  #
  # @param [Vector] offset モデルの中心位置
  # @param [Float] scale モデルの倍率
  # @param [Method] &material 材質を返す関数
  #
  def parse(offset, scale, &material)
    @length.times do |i|
      data = @buffer.unpack('f12', offset: @pointer)

      normal = Vector[data[0], data[2], -data[1]]
      p0 = p(p(Vector[data[3], data[5], -data[4]]) * scale) + offset
      p1 = (Vector[data[6], data[8], -data[7]] * scale) + offset
      p2 = (Vector[data[9], data[11], -data[10]] * scale) + offset

      @triangles[i] = Triangle.new(p0, p1, p2, material.call(i), normal)
      @pointer += (12 << 2) + 2
    end
  end
end
