# frozen_string_literal: true

require_relative 'ray'
require 'matrix'

#
# カメラを表すオブジェクト
#
class Camera
  attr_accessor :base_u, :base_v, :base_w, :origin

  def initialize
    @origin = Vector.zero(3)
    @base_u = Vector.zero(3)
    @base_v = Vector.zero(3)
    @base_w = Vector.zero(3)
  end

  #
  # スクリーン情報からカメラを取得
  #
  # @param [Float] width スクリーンの横幅
  # @param [Float] height スクリーンの縦幅
  # @param [Float] vfov カメラの垂直視野角(度数法)
  #
  # @return [Camera] カメラのインスタンス
  #
  def self.screen(width, height, vfov)
    u = width / height
    v = 1
    Camera.base(Vector[u * 2, 0, 0], Vector[0, v * 2, 0],
                Vector[-u, -v, -v / Math.tan(vfov * 90 / Math::PI)])
  end

  #
  # 基底ベクトルからカメラを取得
  #
  # @param [Float] base_u 基底ベクトルの第1要素
  # @param [Float] base_v 基底ベクトルの第2要素
  # @param [Float] base_w 基底ベクトルの第3要素
  #
  # @return [Camera] カメラのインスタンス
  #
  def self.base(base_u, base_v, base_w)
    camera = Camera.new
    camera.base_u = base_u
    camera.base_v = base_v
    camera.base_w = base_w
    camera
  end

  #
  # 視点を指定してカメラを取得
  #
  # @param [Vector] position カメラの位置
  # @param [Vector] lookat カメラの見る位置
  # @param [Vector] view_up 真上を向く
  # @param [Float] vertical_fov カメラの垂直視野角(ラジアン)
  # @param [Float] aspect スクリーンのアスペクト比
  #
  # @return [Camera] カメラのインスタンス
  #
  def self.lookat(position, lookat, view_up, vertical_fov, aspect)
    camera = Camera.new

    half_h = -Math.tan(vertical_fov * Math::PI / 180.0 / 2.0)
    half_w = aspect * half_h
    camera.origin = position

    w = (lookat - position).normalize
    u = view_up.cross(w).normalize
    v = w.cross(u)

    camera.base_w = position - (half_w * u) - (half_h * v) - w
    camera.base_u = 2.0 * half_w * u
    camera.base_v = 2.0 * half_h * v

    camera
  end

  #
  # スクリーン座標(u,v)を通る光線を取得
  #
  # @param [Float] u スクリーンのx座標
  # @param [Float] v スクリーンのy座標
  #
  # @return [Ray] 光線
  #
  def get_ray(u, v)
    Ray.new(@origin, @base_w + (@base_u * u) + (@base_v * v) - @origin)
  end
end
