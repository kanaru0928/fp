# frozen_string_literal: true

require_relative 'post_effect'

#
# ガンマ補正のポストエフェクト
#
class GammaCorrection < PostEffect
  def apply(_x, _y, color)
    color.r = Math.sqrt(color.r)
    color.g = Math.sqrt(color.g)
    color.b = Math.sqrt(color.b)
    color
  end
end
