# frozen_string_literal: true

require_relative 'shape'

#
# 三角形
#
class Triangle < Shape
  #
  # コンストラクタ
  #
  # @param [Vector] p0 点1
  # @param [Vector] p1 点2
  # @param [Vector] p2 点3
  # @param [Material] material マテリアル
  #
  def initialize(p0, p1, p2, material, normal = nil)
    super()
    @p0 = p0
    @p1 = p1
    @p2 = p2
    @material = material
    @e1 = @p1 - @p0
    @e2 = @p2 - @p0

    @normal = normal || calc_normal
  end

  #
  # 法線を計算
  #
  # @return [Vector] 法線
  #
  def calc_normal
    @e1.cross(@e2)
  end

  def hit(ray, t0, t1)
    alpha = ray.direction.cross(@e2)

    det = @e1.dot(alpha)

    return if det.abs < 1e-6

    invdet = 1.0 / det
    r = ray.origin - @p0

    u = alpha.dot(r) * invdet
    return if u.negative? || u > 1.0

    beta = r.cross(@e1)
    v = ray.direction.dot(beta) * invdet
    return if v.negative? || u + v > 1.0

    t = @e2.dot(beta) * invdet
    return if t0 > t || t > t1

    position = ray.at(t)
    HitRecord.new(t, position, @normal, @material)
  end
end
