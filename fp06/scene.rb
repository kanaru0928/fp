# frozen_string_literal: true

require_relative 'image'
require_relative 'camera'
require_relative 'skybox'
require_relative 'sphere'
require_relative 'shape_list'
require_relative 'triangle'
require_relative 'effect_list'
require_relative 'gamma_correction'
require_relative 'stl'
require_relative 'parallel_func'

#
# シーンを管理するクラス
#
class Scene
  MAX_DEPTH = 30
  INF = 1e9

  #
  # コンストラクタ
  #
  # @param [Float] width 画像の横幅
  # @param [Float] height 画像の縦幅
  # @param [Float] vfov カメラの垂直画角(度数法)
  # @param [Integer] num_sample アンチエイリアスのサンプル数
  #
  def initialize(width, height, vfov, num_sample)
    @width = width
    @height = height
    @vfov = vfov
    @num_sample = num_sample
    @world = ShapeList.new
    # @camera = Camera.screen(width, height, vfov)

    @camera = Camera.lookat(Vector[0, 0, 0], Vector[0, 0, 1], Vector[0, 1, 0], 70, width / height)

    @image = MyImage.new(width, height)

    @post_effect = EffectList.new
  end

  #
  # 色を取得
  #
  # @param [Ray] ray 光線
  # @param [Shape] shape 物体
  #
  # @return [Color] 色
  #
  def get_color(ray, shape, depth)
    return Colors::BLACK if depth <= 0

    skybox = SkyBox.new

    # if ray.nil?
    #   return
    # end

    if (hrec = shape.hit(ray, 1e-4, INF))
      # return skybox.color(hrec.normal)
      # return Color.new(*(255 * 0.5 * (hrec.normal + Vector[1.0, 1.0, 1.0])))

      num_sample = hrec.material.num_sample(depth, MAX_DEPTH)

      # @type [ScatterRecord]
      scatter_rec = hrec.material.scatter(ray, hrec, num_sample)
      # target = hrec.position + hrec.normal + random_sphere_vector

      color = Colors::BLACK

      num_sample.times do |i|
        scattered = scatter_rec.scattereds[i]
        attenuation = scatter_rec.attenuations[i]
        color = Color.add(color, Color.hadamard_product(attenuation, get_color(scattered, shape, depth - 1)))
      end
      return Color.div(color, num_sample)
    end

    skybox.color(ray.direction)
  end

  def build
    # @world.add(Sphere.new(Vector[0.0, 0.0, -1.0], 0.25, Lambertian.new(Colors::PINK)))
    # @world.add(Sphere.new(Vector[0.0, 0.0, -1.0], 0.1))
    @world.add(Sphere.new(Vector[0, -100.5, -1.0], 100.2, Lambertian.new(Colors::LIME)))
    # @world.add(Sphere.new(Vector[-0.1, 0.2, -1.0], 0.05))
    # @world.add(Triangle.new(
    #              Vector[0.6, 0.0, -0.8],
    #              Vector[0.0, 0.3, -1.0],
    #              Vector[0.3, 0.5, -1.1],
    #              Lambertian.new(Colors::ORANGE)
    #            ))

    # @world.add(Triangle.new(
    #              Vector[-0.2137734293937683, -0.30711328983306885, -0.6027056276798248],
    #              Vector[0.4791070222854614, 0.084536612033844, -0.6027056276798248],
    #              Vector[0.23703497648239136, 0.5127939879894257, -1.2283810079097748],
    #              Lambertian.new(Colors::ORANGE),
    #              Vector[0.3868289589881897, 0.6843516230583191, -0.6180827617645264]
    #            ))

    # @world.add(Sphere.new(Vector[-0.2137734293937683, -0.30711328983306885, -0.6027056276798248], 0.05,
    #                       Lambertian.new(Colors::RED)))
    # @world.add(Sphere.new(Vector[0.4791070222854614, 0.084536612033844, -0.6027056276798248], 0.05,
    #                       Lambertian.new(Colors::RED)))
    # @world.add(Sphere.new(Vector[0.23703497648239136, 0.5127939879894257, -1.2283810079097748], 0.05,
    #                       Lambertian.new(Colors::RED)))

    miku = Stl.new('miku.stl')
    color = {
      0 => Colors::SKIN,
      35 => Colors::MIKU,
      96 => Colors::CLOTH,
      138 => Colors::SKIN,
      140 => Colors::CLOTH_DARK,
      142 => Colors::SKIN,
      146 => Colors::CLOTH_DARK,
      150 => Colors::SKIN,
      154 => Colors::CLOTH_DARK,
      156 => Colors::SKIN,
      161 => Colors::CLOTH_DARK,
      163 => Colors::SKIN,
      167 => Colors::CLOTH_DARK,
      171 => Colors::SKIN,
      175 => Colors::CLOTH_DARK,
      177 => Colors::SKIN,
      180 => Colors::MIKU,
      216 => Colors::BLACK,
      220 => Colors::CLOTH_DARK,
      236 => Colors::CLOTH_DARK,
      272 => Colors::SKIN,
      280 => Colors::MIKU
    }

    miku.parse(Vector[0.0, -0.3, -0.8], 1.0) do |i|
      Lambertian.new(color[color.keys.reverse.bsearch { |k| k <= i }] || Colors::GRAY)
    end

    miku.triangles.each do |triangle|
      @world.add(p(triangle))
    end

    @post_effect.add(GammaCorrection.new)

    puts 'build done'
    $stdout.flush
  end

  def func(x, y)
    color = Color.new(0.0, 0.0, 0.0)
    @num_sample.times do |i|
      @num_sample.times do |j|
        u = (x + (i.to_f / @num_sample)) / @width
        v = (y + (j.to_f / @num_sample)) / @height
        ray = @camera.get_ray(u, v)
        color = Color.add(color, get_color(ray, @world, MAX_DEPTH))
      end
    end

    color = Color.div(color, @num_sample * @num_sample)
    color = @post_effect.apply(x, y, color)
  end

  def render
    start = Time.new

    @image.render_parallel(self)
    # @image.render_with(&method(:func))

    puts "rendering takes #{Time.new - start} s."
  end

  def write(name)
    @image.write_image(name)
  end
end
