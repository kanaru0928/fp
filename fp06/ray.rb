# frozen_string_literal: true

require 'matrix'

#
# 光線のオブジェクト
#
class Ray
  # @return [Vector] メンバ変数
  attr_accessor :direction, :origin

  #
  # コンストラクタ
  #
  # @param [Vector] origin 光線の原点
  # @param [Vector] direction 光線の向き
  #
  def initialize(center_rel, direction)
    @origin = center_rel
    @direction = direction
  end

  #
  # tにおける光線の位置を取得
  #
  # @param [Float] t 光線のパラメータ
  #
  # @return [Vector] 光線の位置
  #
  def at(t)
    @origin + (t * @direction)
  end
end
