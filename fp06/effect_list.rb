# frozen_string_literal: true

#
# ポストエフェクトのコレクション
#
class EffectList
  def initialize
    super
    @list = []
  end

  #
  # エフェクトを追加する
  #
  # @param [PostEffect] effect エフェクト
  #
  def add(effect)
    @list.push(effect)
  end

  def apply(x, y, color)
    @list.each do |effect|
      color = effect.apply(x, y, color)
    end
    color
  end
end
