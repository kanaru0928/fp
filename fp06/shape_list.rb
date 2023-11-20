# frozen_string_literal: true

#
# 物体のコレクション
#
class ShapeList < Shape
  #
  # コンストラクター
  #
  def initialize
    super
    @list = []
  end

  #
  # 物体を追加
  #
  # @param [Shape] shape 物体
  #
  # @return [nil]
  #
  def add(shape)
    @list.push(shape)
  end

  def hit(ray, t0, t1)
    ret = false
    closest = t1
    @list.each do |shape|
      if (hrec = shape.hit(ray, t0, closest))
        ret = hrec
        closest = hrec.t
      end
    end

    ret
  end
end
