# frozen_string_literal: true

require_relative 'ray'
require_relative 'hitrecord'
require_relative 'material'

#
# 物体の抽象クラス
#
class Shape
  attr_accessor :material

  def initialize
    @material = Material.new
  end

  #
  # 光線が物体に当たるかどうかを判定
  #
  # @param [Ray] ray 光線
  #
  # @return [HitRec | Boolean] 光線の衝突情報
  #
  def hit(ray) # rubocop:disable Lint/UnusedMethodArgument
    raise 'Not implemented in abstract class.'
  end
end
