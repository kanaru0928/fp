# frozen_string_literal: true

Color = Struct.new(:r, :g, :b) do
  #
  # 色を定数倍
  #
  # @param [Color] c 色
  # @param [Float] k 定数
  #
  # @return [Color] 色
  #
  def self.mul(c, k)
    Color.new(c.r * k, c.g * k, c.b * k)
  end

  def self.normalized(r, g, b)
    Color.new(r / 255.0, g / 255.0, b / 255.0)
  end

  #
  # 色を定数で割る
  #
  # @param [Color] c 色
  # @param [Float] k 定数
  #
  # @return [Color] 色
  #
  def self.div(c, k)
    mul(c, 1.0 / k)
  end

  #
  # 色を足す
  #
  # @param [Color] c1 被加色
  # @param [Color] c2 加色
  #
  # @return [Color] 結果
  #
  def self.add(c1, c2)
    Color.new(c1.r + c2.r, c1.g + c2.g, c1.b + c2.b)
  end

  #
  # 色のアダマール積を取る
  #
  # @param [Color] c1 色1
  # @param [Color] c2 色2
  #
  # @return [Color] 結果
  #
  def self.hadamard_product(c1, c2)
    Color.new(c1.r * c2.r, c1.g * c2.g, c1.b * c2.b)
  end

  def to_image_color
    Color.mul(self, 255.0)
  end
end

class Colors
  BLACK = Color.new(0.0, 0.0, 0.0).freeze
  WHITE = Color.new(1.0, 1.0, 1.0).freeze
  LIME = Color.normalized(0x5f, 0xff, 0x5f).freeze
  PINK = Color.normalized(0xff, 0x5f, 0x5f).freeze
  ORANGE = Color.normalized(0xff, 0xaf, 0x5f).freeze
  GRAY = Color.normalized(0x7f, 0x7f, 0x7f).freeze
end
