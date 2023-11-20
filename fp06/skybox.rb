# frozen_string_literal: true

require_relative 'color'

#
# スカイボックスを表す
#
class SkyBox
  #
  # スカイボックスの色を取得
  #
  # @param [Vector] direction 方向ベクトル
  #
  # @return [Color] 色
  #
  def color(direction)
    ret = Colors::WHITE.dup
    col = direction.angle_with(Vector[0, 1, 0]) / Math::PI * 0.8
    ret.r = col + 0.2
    ret.g = col + 0.2
    ret
  end
end
