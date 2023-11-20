# frozen_string_literal: true

require 'matrix'
require_relative 'color'

# 画像を取り扱うオブジェクト
class MyImage
  #
  # コンストラクタ
  #
  # @param [Integer] width 画像の横幅
  # @param [Integer] height 画像の縦幅
  #
  def initialize(width, height)
    @width = width
    @height = height
    @buffer = Array.new(height) { Array.new(width, Colors::BLACK) }
  end

  #
  # 画像を書き込む
  #
  # @param [String] name 画像のファイル名
  #
  # @return [nil] 返値なし
  #
  def write_image(name)
    open(name, 'wb') do |f|
      f.puts("P6\n#{@width} #{@height}\n255")
      @buffer.each do |a|
        a.each do |px|
          f.write(px.to_image_color.to_a.pack('ccc'))
        end
      end
    end
    puts "Successed to write image into #{name}!"
  end

  def render_with(&func)
    @buffer.length.times do |i|
      @buffer[i].length.times do |j|
        @buffer[i][j] = func.call(j, i)
      end
      puts "#{i + 1} / #{@height} completed."
      $stdout.flush
    end
  end

  def render_parallel(parallel_func)
    ractors = @buffer.size.times.map do |i|
      Ractor.new(@buffer[i].size, i, parallel_func) do |size, i, func_rec|
        ret = Array.new(size)
        size.times do |j|
          ret[j] = func_rec.method(:func).call(j, i)
        end
        puts "#{i + 1} completed."
        $stdout.flush
        ret
      end
    end
    @buffer = ractors.map(&:take)
  end
end
