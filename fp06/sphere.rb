# frozen_string_literal: true

require_relative 'shape'
require 'matrix'
require_relative 'lambertian'

#
# 球
#
class Sphere < Shape
  attr_accessor :center, :radius, :material

  #
  # コンストラクタ
  #
  # @param [Vector] center 中心
  # @param [Float] radius 半径
  # @param [Material] material マテリアル
  #
  def initialize(center, radius, material)
    super()
    @center = center
    @radius = radius
    @material = material
  end

  def hit(ray, t0, t1)
    center_rel = ray.origin - @center
    a = ray.direction.dot(ray.direction)
    b = 2.0 * center_rel.dot(ray.direction)
    c = center_rel.dot(center_rel) - (@radius * @radius)
    d = (b * b) - (4.0 * a * c)

    if d.positive?
      ret = HitRecord.new(-1, Vector.zero(3), Vector.zero(3))
      rt_d = Math.sqrt(d)
      root = (-b - rt_d) / (2.0 * a)
      if root < t1 && root > t0
        ret.t = root
        ret.position = ray.at(root)
        ret.normal = (ret.position - @center) / @radius
        ret.material = @material
        return ret
      end

      root = (-b + rt_d) / (2.0 * a)

      if root < t1 && root > t0
        ret.t = root
        ret.position = ray.at(root)
        ret.normal = (ret.position - @center) / @radius
        ret.material = @material
        return ret
      end
    end

    false
  end
end
