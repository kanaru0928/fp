# frozen_string_literal: true

require_relative 'scatter_record'
require_relative 'material'

#
# 拡散モデルのマテリアル
#
class Lambertian < Material
  def initialize(albedo)
    super()
    @albedo = albedo
  end

  def random_sphere_vector
    vec = Vector.zero(3)
    loop do
      vec = Vector[rand(-1.0..1.0), rand(-1.0..1.0), rand(-1.0..1.0)]
      break if vec.r <= 1
    end
    vec
  end

  def scatter(_ray, hrec, num_sample)
    scattered = Array.new(num_sample)
    attenuation = Array.new(num_sample)
    num_sample.times do |i|
      scatter_direction = hrec.normal + random_sphere_vector
      scattered[i] = Ray.new(hrec.position, scatter_direction)
      attenuation[i] = @albedo
    end
    ScatterRecord.new(scattered, attenuation)
  end
end
