# frozen_string_literal: true

#
# ポストエフェクトの基底クラス
#
class PostEffect
  #
  # ポストエフェクトを適用する
  #
  # @param [Float] x スクリーンのx座標
  # @param [Float] y スクリーンのy座標
  # @param [Color] color ピクセルの色
  #
  # @return [Color] 適用後の色
  #
  def apply(x, y, color)
    raise NotImplementedError
  end
end
